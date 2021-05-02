import * as path from "path";
import * as HtmlWebpackPlugin from "html-webpack-plugin";
import * as CopyPlugin from "copy-webpack-plugin";
import * as webpack from "webpack";
import * as webpackDevServer from "webpack-dev-server";

export const config = (
  env: { [key: string]: string },
  argv: { [key: string]: string }
): webpack.Configuration & { devServer: webpackDevServer.Configuration } => ({
  entry: "./src/index.ts",
  output: {
    filename: "index.[chunkhash].js",
    path: path.join(__dirname, "dist"),
    publicPath: "/", // for spa
  },

  plugins: [
    new HtmlWebpackPlugin.default({
      template: path.join(__dirname, "src/index.html"),
    }),
    new CopyPlugin.default({
      patterns: [{ from: "public", to: "." }],
    }),
    new webpack.DefinePlugin({
      MODE: JSON.stringify(argv["mode"]),
    }),
  ],

  module: {
    rules: [
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: {
          loader: "elm-webpack-loader",
          options: {
            pathToElm: "node_modules/.bin/elm",
            files: [path.resolve(__dirname, "src/Main.elm")],
          },
        },
      },
      {
        test: /\.tsx?$/,
        use: "ts-loader",
        exclude: /node_modules/,
      },
      {
        test: /\.scss/,
        use: [
          "style-loader",
          {
            loader: "css-loader",
            options: {
              url: false,
              importLoaders: 2,
            },
          },
          {
            loader: "sass-loader",
          },
        ],
      },
    ],
  },

  resolve: {
    extensions: [".tsx", ".ts", ".js", ".elm", ".scss"],
  },

  devServer: {
    contentBase: "dist",
    open: true,
    historyApiFallback: true, // for spa
  },
});

export default config;
