# Taste
- Prefers UI/layout work to be hardcoded only (plain Flutter widgets) — the assistant should implement the visual layout and leave state management, navigation, and other logic to the user. Confidence: 0.9
- Wants blocking bugs fixed before continuing with other planned work (e.g., asked to fix the endless-loading issue first, before resuming the Figma layout task). Confidence: 0.5
- When converting Figma designs to code, prefers to provide the Figma link together with the specific screen and layer info (e.g., layer name "00 Profile") so the assistant builds exactly that. Confidence: 0.9
- Is willing to share a Figma Personal Access Token so the assistant can read designs directly via the Figma REST API (node structure JSON + rendered PNGs), rather than relying on screenshots or MCP setup. Confidence: 0.8
- Delegates debugging/fixing of app bugs to the assistant — reports the symptom (e.g., "loading terus", pasted device logs showing failure states) and expects the assistant to investigate root cause, iterate, and fix it. Confidence: 0.95
- Shares raw runtime logs (flutter/device debug output) when reporting a bug, so the assistant can diagnose from actual responses and state transitions. Confidence: 0.85
- Wants real content to actually display (e.g., the profile image) even when the source has server-side SSL/certificate issues — prefers a working in-app workaround (scoped to the problem host) over settling for a placeholder/fallback. Confidence: 0.6
- Communicates in Indonesian (Bahasa Indonesia); prefers replies in Indonesian. Confidence: 0.9
- Likes to verify things himself — asks for the raw API JSON/link (e.g., profile image URL) to check directly, not just the assistant's summary. Confidence: 0.5
