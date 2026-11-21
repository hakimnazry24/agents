# VS Code setup prompt

One prompt per OS that sets up VS Code with my editor layout shortcuts and the shortcuts for moving between Claude Code chats. Copy the prompt for your OS and paste it into Claude Code on the new laptop.

The layout number is how many Claude chats you get.

| Shortcut | Mac | Windows |
|---|---|---|
| Code left, one Claude chat right | Ctrl+Alt+Cmd+1 | Ctrl+Alt+Shift+1 |
| Code left, two Claude chats stacked right | Ctrl+Alt+Cmd+2 | Ctrl+Alt+Shift+2 |
| 2x2 grid: code bottom-left, three Claude chats | Ctrl+Alt+Cmd+3 | Ctrl+Alt+Shift+3 |
| 2x2 grid of four Claude chats | Ctrl+Alt+Cmd+4 | Ctrl+Alt+Shift+4 |
| Reset to one column + Explorer | Ctrl+Alt+Cmd+R | Ctrl+Alt+Shift+R |
| Jump to editor group 1–5 | Alt+1 … Alt+5 | Alt+1 … Alt+5 |
| Jump to the main Claude chat (group 2) | Cmd+Esc | Ctrl+Esc |
| New Claude chat | Cmd+Shift+Esc | Ctrl+Alt+Esc |
| Accept / reject Claude's proposed diff | Cmd+Alt+Enter / Cmd+Alt+Backspace | Ctrl+Alt+Enter / Ctrl+Alt+Backspace |
| Move line up / down | Cmd+Up / Cmd+Down | Ctrl+Up / Ctrl+Down |
| Format document | Cmd+Shift+I | Ctrl+Shift+I |

## Mac

````text
Set up my VS Code on this Mac so the editor layout shortcuts and the shortcuts for moving between Claude Code chats match my setup. Edit these two files:

- ~/Library/Application Support/Code/User/keybindings.json
- ~/Library/Application Support/Code/User/settings.json

Rules:
- Read both files first. Merge into them and never overwrite them. Keep every existing entry that doesn't clash with mine.
- If an existing entry uses the same key or setting as mine, replace it with mine and tell me what you replaced.
- Don't add comments to either file.
- Before writing, back up both files as *.bak.

## What the setup does

Claude Code chats open as editor tabs. Each layout shortcut rearranges the screen and opens Claude chats in fixed spots. The number is how many Claude chats you get:

- Ctrl+Alt+Cmd+1: two side-by-side columns. Code on the left, one Claude chat on the right. The Claude column is locked so files don't open there.
- Ctrl+Alt+Cmd+2: code on the left. On the right, two Claude chats stacked top and bottom, both locked.
- Ctrl+Alt+Cmd+3: a 2x2 grid. Code and images go in the bottom-left (group 2); the other three spots are Claude chats, locked so files and diffs Claude opens land in group 2.
- Ctrl+Alt+Cmd+4: a 2x2 grid of four Claude chats.
- Ctrl+Alt+Cmd+R: closes everything and goes back to one column with the file Explorer open.
- Alt+1 to Alt+5 (Option+1 to Option+5): jump to editor group 1 to 5. This is how I move between Claude chats.
- Cmd+Esc: when I'm not in a Claude chat, jump to group 2 (the main Claude chat). It also works from the terminal.
- Cmd+Shift+Esc: open a new Claude chat.

## Add these to keybindings.json

[
  { "key": "cmd+up", "command": "editor.action.moveLinesUpAction", "when": "editorTextFocus && !editorReadonly" },
  { "key": "alt+up", "command": "-editor.action.moveLinesUpAction", "when": "editorTextFocus && !editorReadonly" },
  { "key": "cmd+down", "command": "editor.action.moveLinesDownAction", "when": "editorTextFocus && !editorReadonly" },
  { "key": "alt+down", "command": "-editor.action.moveLinesDownAction", "when": "editorTextFocus && !editorReadonly" },
  { "key": "shift+cmd+i", "command": "editor.action.formatDocument", "when": "editorHasDocumentFormattingProvider && editorTextFocus && !editorReadonly && !inCompositeEditor" },
  { "key": "shift+alt+f", "command": "-editor.action.formatDocument", "when": "editorHasDocumentFormattingProvider && editorTextFocus && !editorReadonly && !inCompositeEditor" },
  { "key": "cmd+l", "command": "-workbench.action.browser.focusUrlInput", "when": "activeEditor == 'workbench.editor.browser'" },
  { "key": "cmd+l cmd+c", "command": "-fiveServer.close", "when": "editorTextFocus" },
  { "key": "cmd+l cmd+o", "command": "-fiveServer.openViaShortcut", "when": "editorTextFocus" },
  { "key": "cmd+escape", "command": "workbench.action.focusSecondEditorGroup", "when": "activeWebviewPanelId != 'claudeVSCodePanel' && !claude-vscode.sideBarActive" },
  { "key": "cmd+shift+escape", "command": "claude-vscode.primaryEditor.open", "when": "!config.claudeCode.useTerminal" },
  { "key": "cmd+alt+enter", "command": "claude-vscode.acceptProposedDiff", "when": "claude-vscode.viewingProposedDiff" },
  { "key": "cmd+alt+backspace", "command": "claude-vscode.rejectProposedDiff", "when": "claude-vscode.viewingProposedDiff" },
  {
    "key": "ctrl+alt+cmd+4",
    "command": "runCommands",
    "args": { "commands": [
      "workbench.action.closeSidebar",
      "workbench.action.closePanel",
      "workbench.action.focusFirstEditorGroup",
      "workbench.action.joinAllGroups",
      "workbench.action.unlockEditorGroup",
      { "command": "vscode.setEditorLayout", "args": { "orientation": 0, "groups": [
        { "size": 0.5, "groups": [{ "size": 0.5 }, { "size": 0.5 }] },
        { "size": 0.5, "groups": [{ "size": 0.5 }, { "size": 0.5 }] }
      ] } },
      "workbench.action.focusFirstEditorGroup",
      "claude-vscode.primaryEditor.open",
      { "command": "moveActiveEditor", "args": { "by": "group", "to": "first" } },
      "claude-vscode.primaryEditor.open",
      { "command": "moveActiveEditor", "args": { "by": "group", "to": "position", "value": 3 } },
      "claude-vscode.primaryEditor.open",
      { "command": "moveActiveEditor", "args": { "by": "group", "to": "position", "value": 2 } },
      "claude-vscode.primaryEditor.open",
      { "command": "moveActiveEditor", "args": { "by": "group", "to": "position", "value": 4 } },
      "workbench.action.focusFirstEditorGroup"
    ] }
  },
  {
    "key": "ctrl+alt+cmd+r",
    "command": "runCommands",
    "args": { "commands": [
      "workbench.action.closeAllEditors",
      "workbench.action.focusFirstEditorGroup",
      "workbench.action.joinAllGroups",
      "workbench.action.unlockEditorGroup",
      "workbench.action.editorLayoutSingle",
      "workbench.view.explorer"
    ] }
  },
  {
    "key": "ctrl+alt+cmd+1",
    "command": "runCommands",
    "args": { "commands": [
      "workbench.action.closeSidebar",
      "workbench.action.closePanel",
      "workbench.action.focusFirstEditorGroup",
      "workbench.action.joinAllGroups",
      "workbench.action.unlockEditorGroup",
      "claude-vscode.editor.open",
      { "command": "vscode.setEditorLayout", "args": { "orientation": 0, "groups": [{ "size": 0.5 }, { "size": 0.5 }] } },
      { "command": "moveActiveEditor", "args": { "by": "group", "to": "position", "value": 2 } },
      "workbench.action.lockEditorGroup",
      "workbench.action.focusFirstEditorGroup",
      "workbench.action.unlockEditorGroup",
      "workbench.action.focusSecondEditorGroup"
    ] }
  },
  {
    "key": "ctrl+alt+cmd+2",
    "command": "runCommands",
    "args": { "commands": [
      "workbench.action.closeSidebar",
      "workbench.action.closePanel",
      "workbench.action.focusFirstEditorGroup",
      "workbench.action.joinAllGroups",
      "workbench.action.unlockEditorGroup",
      "claude-vscode.editor.open",
      { "command": "vscode.setEditorLayout", "args": { "orientation": 0, "groups": [
        { "size": 0.5 },
        { "size": 0.5, "groups": [{ "size": 0.5 }, { "size": 0.5 }] }
      ] } },
      { "command": "moveActiveEditor", "args": { "by": "group", "to": "position", "value": 2 } },
      "workbench.action.lockEditorGroup",
      "workbench.action.focusThirdEditorGroup",
      "claude-vscode.editor.open",
      { "command": "moveActiveEditor", "args": { "by": "group", "to": "position", "value": 3 } },
      "workbench.action.lockEditorGroup",
      "workbench.action.focusFirstEditorGroup",
      "workbench.action.unlockEditorGroup",
      "workbench.action.focusSecondEditorGroup"
    ] }
  },
  {
    "key": "ctrl+alt+cmd+3",
    "command": "runCommands",
    "args": { "commands": [
      "workbench.action.closeSidebar",
      "workbench.action.closePanel",
      "workbench.action.focusFirstEditorGroup",
      "workbench.action.joinAllGroups",
      "workbench.action.unlockEditorGroup",
      "workbench.action.newGroupRight",
      "workbench.action.focusFirstEditorGroup",
      "workbench.action.newGroupAbove",
      "workbench.action.focusThirdEditorGroup",
      "workbench.action.newGroupBelow",
      "workbench.action.focusFirstEditorGroup",
      "claude-vscode.primaryEditor.open",
      { "command": "moveActiveEditor", "args": { "by": "group", "to": "first" } },
      "claude-vscode.primaryEditor.open",
      { "command": "moveActiveEditor", "args": { "by": "group", "to": "position", "value": 3 } },
      "claude-vscode.primaryEditor.open",
      { "command": "moveActiveEditor", "args": { "by": "group", "to": "position", "value": 4 } },
      "workbench.action.focusFirstEditorGroup",
      "workbench.action.lockEditorGroup",
      "workbench.action.focusThirdEditorGroup",
      "workbench.action.lockEditorGroup",
      "workbench.action.focusFourthEditorGroup",
      "workbench.action.lockEditorGroup",
      "workbench.action.focusSecondEditorGroup",
      "workbench.action.unlockEditorGroup",
      "workbench.action.focusFirstEditorGroup"
    ] }
  },
  { "key": "alt+1", "command": "workbench.action.focusFirstEditorGroup" },
  { "key": "alt+2", "command": "workbench.action.focusSecondEditorGroup" },
  { "key": "alt+3", "command": "workbench.action.focusThirdEditorGroup" },
  { "key": "alt+4", "command": "workbench.action.focusFourthEditorGroup" },
  { "key": "alt+5", "command": "workbench.action.focusFifthEditorGroup" }
]

## Add or update these in settings.json (leave all other settings alone)

{
  "claudeCode.preferredLocation": "panel",
  "claudeCode.focusView": true,
  "claudeCode.hideOnboarding": true,
  "claudeCode.initialPermissionMode": "default",
  "workbench.editor.closeEmptyGroups": false,
  "workbench.editor.enablePreview": false,
  "workbench.secondarySideBar.defaultVisibility": "hidden",
  "workbench.startupEditor": "none",
  "terminal.integrated.commandsToSkipShell": ["workbench.action.focusSecondEditorGroup"]
}

If terminal.integrated.commandsToSkipShell already exists, add the command to the existing list. Don't replace the list.

## After editing

1. Check that both files are still valid JSON. VS Code allows comments and trailing commas in them.
2. Check that the Claude Code extension (anthropic.claude-code) is installed. Run `code --list-extensions` and install it if it's missing. If the `code` command isn't found, tell me to run "Shell Command: Install 'code' command in PATH" from the VS Code command palette.
3. Tell me whether macOS or another app grabs any of these keys before VS Code sees them. Cmd+Shift+Esc and Cmd+Esc are the ones to check first, and apps like Raycast, Alfred, Rectangle or Magnet often bind Ctrl+Alt+Cmd combos. Look in System Settings > Keyboard > Keyboard Shortcuts too. For each blocked key, suggest a free replacement and ask me before you change it.
4. Give me a short table of every shortcut and what it does, then tell me to reload the window (Developer: Reload Window) and test each layout shortcut.
````

## Windows

````text
Set up my VS Code on this Windows laptop so the editor layout shortcuts and the shortcuts for moving between Claude Code chats match my Mac setup. Edit these two files:

- %APPDATA%\Code\User\keybindings.json
- %APPDATA%\Code\User\settings.json

Rules:
- Read both files first. Merge into them and never overwrite them. Keep every existing entry that doesn't clash with mine.
- If an existing entry uses the same key or setting as mine, replace it with mine and tell me what you replaced.
- Don't add comments to either file.
- Before writing, back up both files as *.bak.

## What the setup does

Claude Code chats open as editor tabs. Each layout shortcut rearranges the screen and opens Claude chats in fixed spots. The number is how many Claude chats you get:

- Ctrl+Alt+Shift+1: two side-by-side columns. Code on the left, one Claude chat on the right. The Claude column is locked so files don't open there.
- Ctrl+Alt+Shift+2: code on the left. On the right, two Claude chats stacked top and bottom, both locked.
- Ctrl+Alt+Shift+3: a 2x2 grid. Code and images go in the bottom-left (group 2); the other three spots are Claude chats, locked so files and diffs Claude opens land in group 2.
- Ctrl+Alt+Shift+4: a 2x2 grid of four Claude chats.
- Ctrl+Alt+Shift+R: closes everything and goes back to one column with the file Explorer open.
- Alt+1 to Alt+5: jump to editor group 1 to 5. This is how I move between Claude chats.
- Ctrl+Esc: when I'm not in a Claude chat, jump to group 2 (the main Claude chat). It also works from the terminal.

## Mac to Windows key mapping I've chosen

Cmd becomes Ctrl. My Mac layout keys (Ctrl+Alt+Cmd+1 to 4 and R) become Ctrl+Alt+Shift+1 to 4 and R, because VS Code can't bind the Windows key. Ctrl+Shift+Esc opens Task Manager on Windows, so the "new Claude chat" shortcut becomes Ctrl+Alt+Esc.

## Add these to keybindings.json

[
  { "key": "ctrl+up", "command": "editor.action.moveLinesUpAction", "when": "editorTextFocus && !editorReadonly" },
  { "key": "alt+up", "command": "-editor.action.moveLinesUpAction", "when": "editorTextFocus && !editorReadonly" },
  { "key": "ctrl+down", "command": "editor.action.moveLinesDownAction", "when": "editorTextFocus && !editorReadonly" },
  { "key": "alt+down", "command": "-editor.action.moveLinesDownAction", "when": "editorTextFocus && !editorReadonly" },
  { "key": "ctrl+shift+i", "command": "editor.action.formatDocument", "when": "editorHasDocumentFormattingProvider && editorTextFocus && !editorReadonly && !inCompositeEditor" },
  { "key": "shift+alt+f", "command": "-editor.action.formatDocument", "when": "editorHasDocumentFormattingProvider && editorTextFocus && !editorReadonly && !inCompositeEditor" },
  { "key": "ctrl+l", "command": "-workbench.action.browser.focusUrlInput", "when": "activeEditor == 'workbench.editor.browser'" },
  { "key": "ctrl+l ctrl+c", "command": "-fiveServer.close", "when": "editorTextFocus" },
  { "key": "ctrl+l ctrl+o", "command": "-fiveServer.openViaShortcut", "when": "editorTextFocus" },
  { "key": "ctrl+escape", "command": "workbench.action.focusSecondEditorGroup", "when": "activeWebviewPanelId != 'claudeVSCodePanel' && !claude-vscode.sideBarActive" },
  { "key": "ctrl+alt+escape", "command": "claude-vscode.primaryEditor.open", "when": "!config.claudeCode.useTerminal" },
  { "key": "ctrl+alt+enter", "command": "claude-vscode.acceptProposedDiff", "when": "claude-vscode.viewingProposedDiff" },
  { "key": "ctrl+alt+backspace", "command": "claude-vscode.rejectProposedDiff", "when": "claude-vscode.viewingProposedDiff" },
  {
    "key": "ctrl+alt+shift+4",
    "command": "runCommands",
    "args": { "commands": [
      "workbench.action.closeSidebar",
      "workbench.action.closePanel",
      "workbench.action.focusFirstEditorGroup",
      "workbench.action.joinAllGroups",
      "workbench.action.unlockEditorGroup",
      { "command": "vscode.setEditorLayout", "args": { "orientation": 0, "groups": [
        { "size": 0.5, "groups": [{ "size": 0.5 }, { "size": 0.5 }] },
        { "size": 0.5, "groups": [{ "size": 0.5 }, { "size": 0.5 }] }
      ] } },
      "workbench.action.focusFirstEditorGroup",
      "claude-vscode.primaryEditor.open",
      { "command": "moveActiveEditor", "args": { "by": "group", "to": "first" } },
      "claude-vscode.primaryEditor.open",
      { "command": "moveActiveEditor", "args": { "by": "group", "to": "position", "value": 3 } },
      "claude-vscode.primaryEditor.open",
      { "command": "moveActiveEditor", "args": { "by": "group", "to": "position", "value": 2 } },
      "claude-vscode.primaryEditor.open",
      { "command": "moveActiveEditor", "args": { "by": "group", "to": "position", "value": 4 } },
      "workbench.action.focusFirstEditorGroup"
    ] }
  },
  {
    "key": "ctrl+alt+shift+r",
    "command": "runCommands",
    "args": { "commands": [
      "workbench.action.closeAllEditors",
      "workbench.action.focusFirstEditorGroup",
      "workbench.action.joinAllGroups",
      "workbench.action.unlockEditorGroup",
      "workbench.action.editorLayoutSingle",
      "workbench.view.explorer"
    ] }
  },
  {
    "key": "ctrl+alt+shift+1",
    "command": "runCommands",
    "args": { "commands": [
      "workbench.action.closeSidebar",
      "workbench.action.closePanel",
      "workbench.action.focusFirstEditorGroup",
      "workbench.action.joinAllGroups",
      "workbench.action.unlockEditorGroup",
      "claude-vscode.editor.open",
      { "command": "vscode.setEditorLayout", "args": { "orientation": 0, "groups": [{ "size": 0.5 }, { "size": 0.5 }] } },
      { "command": "moveActiveEditor", "args": { "by": "group", "to": "position", "value": 2 } },
      "workbench.action.lockEditorGroup",
      "workbench.action.focusFirstEditorGroup",
      "workbench.action.unlockEditorGroup",
      "workbench.action.focusSecondEditorGroup"
    ] }
  },
  {
    "key": "ctrl+alt+shift+2",
    "command": "runCommands",
    "args": { "commands": [
      "workbench.action.closeSidebar",
      "workbench.action.closePanel",
      "workbench.action.focusFirstEditorGroup",
      "workbench.action.joinAllGroups",
      "workbench.action.unlockEditorGroup",
      "claude-vscode.editor.open",
      { "command": "vscode.setEditorLayout", "args": { "orientation": 0, "groups": [
        { "size": 0.5 },
        { "size": 0.5, "groups": [{ "size": 0.5 }, { "size": 0.5 }] }
      ] } },
      { "command": "moveActiveEditor", "args": { "by": "group", "to": "position", "value": 2 } },
      "workbench.action.lockEditorGroup",
      "workbench.action.focusThirdEditorGroup",
      "claude-vscode.editor.open",
      { "command": "moveActiveEditor", "args": { "by": "group", "to": "position", "value": 3 } },
      "workbench.action.lockEditorGroup",
      "workbench.action.focusFirstEditorGroup",
      "workbench.action.unlockEditorGroup",
      "workbench.action.focusSecondEditorGroup"
    ] }
  },
  {
    "key": "ctrl+alt+shift+3",
    "command": "runCommands",
    "args": { "commands": [
      "workbench.action.closeSidebar",
      "workbench.action.closePanel",
      "workbench.action.focusFirstEditorGroup",
      "workbench.action.joinAllGroups",
      "workbench.action.unlockEditorGroup",
      "workbench.action.newGroupRight",
      "workbench.action.focusFirstEditorGroup",
      "workbench.action.newGroupAbove",
      "workbench.action.focusThirdEditorGroup",
      "workbench.action.newGroupBelow",
      "workbench.action.focusFirstEditorGroup",
      "claude-vscode.primaryEditor.open",
      { "command": "moveActiveEditor", "args": { "by": "group", "to": "first" } },
      "claude-vscode.primaryEditor.open",
      { "command": "moveActiveEditor", "args": { "by": "group", "to": "position", "value": 3 } },
      "claude-vscode.primaryEditor.open",
      { "command": "moveActiveEditor", "args": { "by": "group", "to": "position", "value": 4 } },
      "workbench.action.focusFirstEditorGroup",
      "workbench.action.lockEditorGroup",
      "workbench.action.focusThirdEditorGroup",
      "workbench.action.lockEditorGroup",
      "workbench.action.focusFourthEditorGroup",
      "workbench.action.lockEditorGroup",
      "workbench.action.focusSecondEditorGroup",
      "workbench.action.unlockEditorGroup",
      "workbench.action.focusFirstEditorGroup"
    ] }
  },
  { "key": "alt+1", "command": "workbench.action.focusFirstEditorGroup" },
  { "key": "alt+2", "command": "workbench.action.focusSecondEditorGroup" },
  { "key": "alt+3", "command": "workbench.action.focusThirdEditorGroup" },
  { "key": "alt+4", "command": "workbench.action.focusFourthEditorGroup" },
  { "key": "alt+5", "command": "workbench.action.focusFifthEditorGroup" }
]

## Add or update these in settings.json (leave all other settings alone)

{
  "claudeCode.preferredLocation": "panel",
  "claudeCode.focusView": true,
  "claudeCode.hideOnboarding": true,
  "claudeCode.initialPermissionMode": "default",
  "workbench.editor.closeEmptyGroups": false,
  "workbench.editor.enablePreview": false,
  "workbench.secondarySideBar.defaultVisibility": "hidden",
  "workbench.startupEditor": "none",
  "terminal.integrated.commandsToSkipShell": ["workbench.action.focusSecondEditorGroup"]
}

If terminal.integrated.commandsToSkipShell already exists, add the command to the existing list. Don't replace the list.

## After editing

1. Check that both files are still valid JSON. VS Code allows comments and trailing commas in them.
2. Check that the Claude Code extension (anthropic.claude-code) is installed. Run `code --list-extensions` and install it if it's missing.
3. Tell me whether Windows grabs any of these keys before VS Code sees them. Ctrl+Esc opens the Start menu, Ctrl+Alt+Esc is the one most likely to be blocked, and Ctrl+Alt combos can act as AltGr on non-US keyboards. For each blocked key, suggest a free replacement and ask me before you change it.
4. Give me a short table of every shortcut and what it does, then tell me to reload the window (Developer: Reload Window) and test each layout shortcut.
````
