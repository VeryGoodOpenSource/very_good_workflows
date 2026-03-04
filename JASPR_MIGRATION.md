# Migrating from Docusaurus to Jaspr

## 1. Scaffold the Jaspr project

```bash
dart pub global activate jaspr_cli
jaspr create --template=docs site_jaspr
```

This gives you a Jaspr static site pre-configured with `jaspr_content`, which includes a `DocsLayout` with sidebar, header, dark/light mode, markdown parsing, and syntax highlighting out of the box.

## 2. Migrate your content

Your current docs are 10 Markdown files in `site/docs/` with YAML frontmatter (`sidebar_position`, `title`, `description`). These can largely be copied over as-is -- `jaspr_content` uses a `FilesystemLoader` that reads `.md` files from a content directory and supports frontmatter.

The current sidebar is auto-generated from the filesystem in Docusaurus. In Jaspr, the sidebar is defined explicitly in Dart code:

```dart
sidebar: Sidebar(groups: [
  SidebarGroup(links: [
    SidebarLink(text: 'Overview', href: '/'),
  ]),
  SidebarGroup(title: 'Workflows', links: [
    SidebarLink(text: 'Dart Package', href: '/workflows/dart_package'),
    SidebarLink(text: 'Flutter Package', href: '/workflows/flutter_package'),
    // ... etc
  ]),
]),
```

## 3. Recreate the custom homepage

The current homepage (`site/src/pages/index.tsx`) is a custom React component with a hero banner, CTA button, and blog section. In Jaspr, you'd build this as a `StatelessComponent` using Jaspr's HTML element functions (`div`, `a`, `img`, etc.) with typed `Styles` for CSS.

## 4. Migrate theming

The custom CSS (`site/src/css/custom.css`) defines brand colors, Poppins font, and dark mode overrides. In Jaspr, theming is done via `ContentTheme`:

```dart
theme: ContentTheme(
  primary: ThemeColor(Color('#2a48df'), dark: Color('#66fbd1')),
  background: ThemeColor(Colors.white, dark: Color('#0b0d0e')),
),
```

## 5. Update the deployment workflow

Replace the Node/Docusaurus build steps in `.github/workflows/site_deploy.yaml` with Dart/Jaspr:

```yaml
- uses: dart-lang/setup-dart@v1
- run: dart pub global activate jaspr_cli
- run: jaspr build
# Output goes to build/jaspr/ instead of site/build/
```

## Key differences to be aware of

| Aspect | Docusaurus (current) | Jaspr |
|---|---|---|
| Sidebar | Auto-generated from filesystem | Manual definition in Dart |
| Custom pages | React/TSX components | Dart `StatelessComponent` |
| Styling | CSS/CSS Modules | Typed `Styles` in Dart + optional CSS |
| Markdown extensions | MDX (JSX in Markdown) | Custom components registered in Dart |
| Search | Algolia integration available | No built-in search |
| Docs versioning | Built-in | Not available |

## Tradeoffs

The main benefit is staying entirely within the Dart ecosystem. The main costs are losing Docusaurus's auto-generated sidebar, built-in search integration, and the broader plugin ecosystem. The site is relatively straightforward (10 doc pages, one custom homepage), so the migration scope is manageable.
