---
name: Fluent InfoBar lifecycle
description: Duplicate Fluent InfoBars need explicit active-notice tracking.
---

`fluent.displayInfoBar` returns after inserting its overlay entry; its future does not represent the notice's visible lifetime or dismissal.

**Why:** Using the returned future to clear a deduplication record releases it immediately, allowing repeated notices to stack.

**How to apply:** Track each active message independently and expire it using the configured display duration plus the Fluent entrance/exit animation time. Clear early when the user closes the InfoBar.
