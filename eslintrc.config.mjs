import eslint from "@eslint/js";
import { defineConfig, globalIgnores } from "eslint/config";
import globals from "globals";
import tseslint from "typescript-eslint";

export default defineConfig(
  globalIgnores([".yarn/*"]),
  eslint.configs.recommended,
  tseslint.configs.recommendedTypeChecked,
  {
    languageOptions: {
      globals: {
        ...globals.node
      },
      parserOptions: {
        projectService: {
          allowDefaultProject: [
            "eslint.config.mjs",
            "prettier.config.mjs",
            "test/jest.config.cjs"
          ]
        },
      }
    }
  },
  {
    rules: {
      "@typescript-eslint/no-unnecessary-type-arguments": "error",
      "@typescript-eslint/no-unused-vars": [
        "error",
        { varsIgnorePattern: "^_", argsIgnorePattern: "^_" }
      ],

      "linebreak-style": ["error", "unix"],

      quotes: ["warn", "double", { avoidEscape: true }],

      "no-shadow": "error"
    }
  }
);
