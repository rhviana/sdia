# FAQ 07 — How is Sender A isolated from Sender B?

## Traditional Model
- Separate proxies
- Separate credentials

## GDCR Model

Authorization key:
Sender × Domain × Entity × Action


ASCII:

+--------+--------+---------+--------+
| Sender | Domain | Entity | Action |
+--------+--------+---------+--------+
| A | sales | orders | create |
| B | sales | orders | read |


If no match → FAIL FAST
