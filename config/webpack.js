var webpack = require('webpack');

module.exports = {
  entry: './web/static/js/app.js',
  output: {
    path: __dirname + '/../priv/static/js',
    filename: 'app.js'
  },
  devtool: 'source-map',
  module: {
    loaders: [
      { test: /\.jsx?$/, exclude: /node_modules|web\/static\/vendor/, loader: 'babel-loader' }
    ]
  },
  resolve: {
    extensions: ['', '.js', '.jsx']
  }
};
