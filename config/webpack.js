var webpack = require('webpack');

module.exports = {
  entry: './web/static/js/app.jsx',
  output: {
    path: __dirname + '/../priv/static/js',
    filename: 'app.js'
  },
  devtool: 'source-map',
  module: {
    loaders: [
      {
        test: /\.jsx?$/,
        exclude: /node_modules|web\/static\/vendor/,
        loader: 'babel',
        query: { presets: ['es2015', 'react'] }
      }
    ]
  },
  resolve: {
    extensions: ['', '.js', '.jsx']
  }
};
