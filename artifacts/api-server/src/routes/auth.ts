import { createHmac, timingSafeEqual } from "node:crypto";
import { Router, type IRouter, type Request, type Response } from "express";

const router: IRouter = Router();
const roles = ["admin", "cashier1", "cashier2", "auditor"] as const;
type Role = (typeof roles)[number];

const rolePermissions: Record<Role, ReadonlySet<string>> = {
  admin: new Set([
    "inventory.view", "inventory.manage", "inventory.delete",
    "accounts.view", "accounts.manage", "accounts.delete",
    "invoice.view", "invoice.save", "invoice.deleteDraft", "invoice.print",
    "invoice.discount", "barcode.view", "barcode.print", "admin.users",
    "invoice.approve", "admin.company", "admin.backup",
  ]),
  cashier1: new Set([
    "inventory.view", "accounts.view", "invoice.view", "invoice.save",
    "invoice.print", "invoice.discount", "barcode.view", "barcode.print",
  ]),
  cashier2: new Set([
    "inventory.view", "accounts.view", "invoice.view", "invoice.save",
    "barcode.view", "barcode.print",
  ]),
  auditor: new Set([
    "inventory.view", "accounts.view", "invoice.view", "invoice.print",
    "barcode.view", "barcode.print",
  ]),
};

type SessionPayload = {
  username: string;
  role: Role;
  expiresAt: number;
};

function signingSecret(): string | undefined {
  return process.env["SESSION_SECRET"];
}

function configuredPasswords(): Partial<Record<Role, string>> | undefined {
  const value = process.env["ACCOUNTING_ROLE_PASSWORDS"];
  if (value) {
    try {
      const parsed: unknown = JSON.parse(value);
      if (
        parsed &&
        typeof parsed === "object" &&
        roles.every((role) => typeof (parsed as Record<string, unknown>)[role] === "string" &&
          ((parsed as Record<string, string>)[role]?.length ?? 0) >= 8)
      ) {
        return parsed as Record<Role, string>;
      }
    } catch {
      return undefined;
    }
    return undefined;
  }
  if (process.env["NODE_ENV"] !== "production") {
    return { admin: "1233", cashier1: "1233", cashier2: "1233", auditor: "1233" };
  }
  return undefined;
}

function sign(encodedPayload: string, secret: string): string {
  return createHmac("sha256", secret).update(encodedPayload).digest("base64url");
}

function tokenFor(payload: SessionPayload, secret: string): string {
  const encoded = Buffer.from(JSON.stringify(payload)).toString("base64url");
  return `${encoded}.${sign(encoded, secret)}`;
}

function readSession(req: Request): SessionPayload | undefined {
  const secret = signingSecret();
  const authorization = req.header("authorization") ?? "";
  const token = authorization.startsWith("Bearer ")
    ? authorization.slice("Bearer ".length)
    : "";
  const [encoded, suppliedSignature, extra] = token.split(".");
  if (!secret || !encoded || !suppliedSignature || extra) return undefined;

  const expected = Buffer.from(sign(encoded, secret));
  const supplied = Buffer.from(suppliedSignature);
  if (
    expected.length !== supplied.length ||
    !timingSafeEqual(expected, supplied)
  ) return undefined;

  try {
    const payload: unknown = JSON.parse(
      Buffer.from(encoded, "base64url").toString("utf8"),
    );
    if (
      !payload || typeof payload !== "object" ||
      typeof (payload as SessionPayload).username !== "string" ||
      !roles.includes((payload as SessionPayload).role) ||
      typeof (payload as SessionPayload).expiresAt !== "number" ||
      (payload as SessionPayload).expiresAt <= Date.now()
    ) return undefined;
    return payload as SessionPayload;
  } catch {
    return undefined;
  }
}

function requireSession(req: Request, res: Response): SessionPayload | undefined {
  if (!signingSecret()) {
    res.status(503).json({ error: "authentication_unconfigured" });
    return undefined;
  }
  const session = readSession(req);
  if (!session) res.status(401).json({ error: "unauthorized" });
  return session;
}

router.post("/auth/login", (req, res) => {
  const secret = signingSecret();
  const passwords = configuredPasswords();
  if (!secret || !passwords) {
    res.status(503).json({ error: "authentication_unconfigured" });
    return;
  }

  const username = req.body?.username;
  const password = req.body?.password;
  if (
    typeof username !== "string" ||
    !roles.includes(username as Role) ||
    typeof password !== "string"
  ) {
    res.status(401).json({ error: "invalid_credentials" });
    return;
  }
  const role = username as Role;
  const expected = Buffer.from(passwords[role] ?? "");
  const supplied = Buffer.from(password);
  if (
    expected.length === 0 ||
    expected.length !== supplied.length ||
    !timingSafeEqual(expected, supplied)
  ) {
    res.status(401).json({ error: "invalid_credentials" });
    return;
  }

  const payload: SessionPayload = {
    username: role,
    role,
    expiresAt: Date.now() + 8 * 60 * 60 * 1000,
  };
  res.json({ username: role, role, token: tokenFor(payload, secret) });
});

router.post("/auth/authorize", (req, res) => {
  const session = requireSession(req, res);
  if (!session) return;

  const permission = req.body?.permission;
  if (typeof permission !== "string") {
    res.status(400).json({ error: "invalid_permission" });
    return;
  }
  if (!rolePermissions[session.role].has(permission)) {
    res.status(403).json({ error: "forbidden" });
    return;
  }
  res.json({ authorized: true, role: session.role });
});

export default router;
