---
name: ui-preview
description: Build a throwaway visual preview of a frontend design change, outside the repo, and get the user's approval before implementing it. Use during planning whenever a change alters how a UI looks (new screen, layout, component, styling, copy on screen), when the ui-preview reminder hook fires, or when the user says "preview", "mockup" or "show me the design first". Also covers setting up previews for a new frontend project.
---

# UI preview

Previews live in `~/ui-previews/<project>/`, never in the repo. They import the repo's real components, CSS and Tailwind config read-only, so they look exactly like the app. Read `~/ui-previews/README.md` for the layout.

## When the user wants a design change

1. **Find the project.** Match the repo's frontend path against `frontendPath` in `~/ui-previews/*/preview.config.json`. If none matches, do "Set up a new project" below first (ask before doing it).
2. **Write the preview** at `~/ui-previews/<project>/previews/<feature-name>/Preview.tsx` with a default-exported component. Kebab-case feature name.
   - Import real components through the repo's aliases (e.g. `@/design/shadcn/button`). Reuse existing components over new markup.
   - Use hard-coded fake data and never call the real API.
   - To show (or change) an existing screen that fetches data, render the real page instead of copying it: put fixtures in `fixtures.ts` next to the preview, swap the app's shared HTTP client for a fake one in `fakeApi.ts` (e.g. set the axios instance's `defaults.adapter` to return fixtures by URL; writes resolve with no change), and wrap the page in a fake session/auth provider. `~/ui-previews/connector/previews/salescare-current/` is the worked example.
   - Show every state that matters side by side or stacked (empty, loading, error, filled, long text), and open dialogs/menus by default so a screenshot shows them.
   - Follow the repo's code style; no comments.
3. **Run it.** If the port in `preview.config.json` isn't already serving, start `npm run dev` in `~/ui-previews/<project>` in the background.
4. **Screenshot it.** Use the Playwright MCP browser; if it's busy or unavailable, run `~/ui-previews/screenshot.sh <url> <scratchpad>/<feature>.png [width,height]`. Read the PNG yourself and fix anything broken before showing the user.
5. **Present it** as part of the plan: the URL (`http://localhost:<port>/<feature-name>`), the screenshot path, and one line per design decision worth questioning.
6. **Iterate** on the preview until the user approves the design. Do not edit repo frontend files for this change before they approve.
7. **Implement** to match the approved preview. Leave the preview folder in place; the user deletes old ones.

Stop the dev server when the session's design work is done.

## Set up a new project

1. Run `~/ui-previews/new-project.sh <name> <absolute-frontend-path>` (the frontend must have `node_modules` installed).
2. Fill in `~/ui-previews/<name>/preview.config.json`:
   - `aliases` — copy from the repo's `vite.config.ts` `resolve.alias` or `tsconfig` `paths`, as paths relative to the frontend.
   - `cssEntry` — the global CSS the app's entry imports.
   - `tailwindConfig`, `tailwindContent` — the repo's Tailwind config file and its content globs.
   - `port` — a port not used by any other `~/ui-previews/*/preview.config.json` or the app's own dev server.
3. Put the app's top-level providers (router, tooltip, toaster, theme…) in `providers.tsx`, using a `MemoryRouter` instead of a browser router.
4. Mirror the aliases in `tsconfig.json` `paths` for editor support.
5. Verify: write a `previews/sample/Preview.tsx` using two or three real components, run it, screenshot it, and check fonts, colours and spacing match the real app.

The template targets React + Tailwind 3 frontends that Vite can build. For other stacks (Next.js-only APIs, Tailwind 4, CSS-in-JS), adapt that project's copy of `vite.config.ts` and say what changed; don't change `_template/` for one project.
