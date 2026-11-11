---
name: Inventory group variants
description: How related inventory items share a group while keeping distinct billable units.
---

When New is clicked while editing an item, keep the item-level fields and append a unit row to the same item. Each row has its own price, unit type, barcode, color, and quick-sale flag. Invoices should show each unit row as a billable choice at its own price and display its unit label. Re-adding the same item and unit increments the existing invoice line quantity; different units remain separate lines.

**Why:** The user clarified that adding within the same group means adding a row to the existing item's unit table, not creating a separate item record, and that repeated selection of the same invoiced item should increase quantity.

**How to apply:** While editing, collect the current form values before appending a unit row; do not clear item fields or save a separate item. Keep unit rows individually selectable in invoices.
