import * as path from "path";
import HtmlWebpackPlugin from "html-webpack-plugin";
import CopyPlugin from "copy-webpack-plugin";
import * as webpack from "webpack";

export const config = {
  mode: process.env.NODE_ENV,
  entry: "./src/index.ts",
  output: {
    filename: "index.[chunkhash].js",
    path: path.join(__dirname, "dist"),
    publicPath: "/", // for spa
  },

  plugins: [
    new HtmlWebpackPlugin({
      template: path.join(__dirname, "src/index.html"),
    }),
    new CopyPlugin({
      patterns: [{ from: "public", to: "." }],
    }),
    new webpack.DefinePlugin({
      MODE: JSON.stringify(process.env.NODE_ENV),
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
};

export default config;
