// eslint-disable-next-line no-undef
module.exports = {
  root: true,
  parser: "@typescript-eslint/parser",
  plugins: ["@typescript-eslint"],
  // ESLint will now know that `document`/`window`/etc exist
  // https://eslint.org/docs/user-guide/configuring#specifying-environments
  env: { browser: true },
  extends: [
    "eslint:recommended",
    "plugin:@typescript-eslint/recommended",
    // Don't complain about things that Prettier will fix
    "prettier/@typescript-eslint",
    // React
    "plugin:react/recommended",
    // Enforce the Rules of React Hooks
    "plugin:react-hooks/recommended",
  ],
  rules: {
    // Typescript handles the types
    "react/prop-types": "off",
    "no-console": "error",
    "array-callback-return": "error",
    "no-sequences": "error",
  },
  settings: {
    react: {
      version: "detect",
    }
  }
};
