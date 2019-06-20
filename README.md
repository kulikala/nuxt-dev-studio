# nuxt-dev-studio

[![docker build automated](https://img.shields.io/docker/automated/kulikala/nuxt-dev-studio.svg?style=flat-square)](https://hub.docker.com/r/kulikala/nuxt-dev-studio)
[![docker build status](https://img.shields.io/docker/build/kulikala/nuxt-dev-studio.svg?style=flat-square)](https://hub.docker.com/r/kulikala/nuxt-dev-studio)
[![docker pulls](https://img.shields.io/docker/pulls/kulikala/nuxt-dev-studio.svg?style=flat-square)](https://hub.docker.com/r/kulikala/nuxt-dev-studio)
[![microbadger image size](https://img.shields.io/microbadger/image-size/kulikala/nuxt-dev-studio/latest.svg?style=flat-square)](https://microbadger.com/images/kulikala/nuxt-dev-studio)
[![microbadger layers](https://img.shields.io/microbadger/layers/kulikala/nuxt-dev-studio/latest.svg?style=flat-square)](https://microbadger.com/images/kulikala/nuxt-dev-studio)
[![MIT License](https://img.shields.io/badge/licence-MIT-blue.svg?style=flat-square)](LICENSE)

Easy to use, all in one Nuxt.js development environment

## 3 steps to start

### 1. Install Docker

[https://www.docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop)

### 2. Open terminal and type:

```bash
sh -c "$(curl -fSsL git.io/nuxt-dev-studio)"
```

_**Note**: This will setup a new Nuxt.js project **in the current directory**.<br>
`cd` to your working directory before running this._

### 3. Start Nuxt.js!

```bash
./studio dev
```

then, visit [http://localhost:3000](http://localhost:3000) to see your Nuxt.js page.

Press `Ctrl+C` to stop running.

## What's this?

`nuxt-dev-studio` offers a Docker image and everything needed is included when you develop a Vue.js application with the Nuxt.js framework.

* Node.js environment
* `npm` and `npx`
* `git`
* Scaffolding script to quick start a Nuxt.js project
* Quick setting-up pre-processors: `pug`, `coffee`, `less`, `scss`, `sass`, `stylus`
* Template generator for components and pages

## Why this?

I believe `nuxt-dev-studio` suites for ones whom:

* want to start developing Vue.js/Nuxt.js application for the first time
* need a quick Node.js environment without laborious installation process
* want to try out Vue.js/Nuxt.js with less steps
* need a separated environment for tryout and/or development
* want to use pre-processors without troublesome works

## Prerequisites

`nuxt-dev-studio` requires Docker to have been installed.

[https://www.docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop)

## Install

Install with curl.

_**Note**: This script is for environments with `/bin/bash`_

```bash
sh -c "$(curl -fSsL git.io/nuxt-dev-studio)"
```

Or, download and setup.

```bash
wget git.io/nuxt-dev-studio
sh nuxt-dev-studio
```

This will setup a new Nuxt.js project **in the current directory**.

If you want your new project to be set up in a new directory, pass the name like this:

```bash
sh -c "$(curl -L git.io/nuxt-dev-studio)" -s <your-project-name>
```

_**Note**: This script triggers `npx create-nuxt-app <your-project-name>`_

### Next step

After successful installation, you'll have `studio` command in your directory.

Type in the console:

```bash
./studio dev
```

and visit [http://localhost:3000](http://localhost:3000) to see your Nuxt.js page.

Voila!

### Use `pug` and other pre-processors

_**Note**: if you already started `./studio dev`, press `Ctrl+C` to stop this_

Pre-processors are easy to set up.

#### # `pug`

If you want to use `pug` for `<template>` part, just type:

```bash
./studio install pug
```

Now change `<template>` declaration to `<template lang="pug">` like:

```pug
<template lang="pug">
  div
    form(
      method="post"
      action="/path/to/post/endpoint"
    )
      label(
        for="username"
      )
        input(
          id="username"
          type="text"
        )
</template>
```

#### # `less`, `scss`, `sass`, `stylus`

Pre-processors for CSS are available.

For example, type:

```bash
./studio install stylus
```

Then, you can change `<style>` declaration to `<style lang="stulus">` like:

```stylus
<style lang="stylus">
form
  label
    font-size larger
  input[type=text]
    border none
    color grey
</style>
```

#### # `coffee`

CoffeeScript is available for `<​script>` declaration like `<​script lang="coffee">`

```bash
./studio install coffee
```

Then, you need to edit `nuxt.config.js` and add:

```javascript
config.module.rules.push({
  test: /\.coffee$/,
  use: 'coffee-loader',
  exclude: /(node_modules)/
})
```

## Other commands and usage

### `./studio dev`

Launch a development server on `localhost:3000` with hot-reloading.

### `./studio build`

Build your application with webpack and minify the JS & CSS (for production).

### `./studio start`

Start the server in production mode (after running `./studio build`).

### `./studio generate`

Build the application and generate every route as a HTML file (used for static hosting).

### `./studio lint`

Lint source codes.

_**Note**: This command is only enabled when the `lint` field exists in the `scripts` property in `package.json`_

### `./studio test`

Run test commands.

_**Note**: This command is only enabled when the `test` field exists in the `scripts` property in `package.json`_

### `./studio add <type> <name>`

Add template component, layout, page, or store.

Available `<type>`: `components`, `layouts`, `pages`, `store`

### `./studio install <name>`

Install pre-processors.

Available `<name>`: `coffee`, `pug`, `less`, `scss`, `sass`, `stylus`

Type `./studio install help` to show available pre-processors.

### `./studio git <ARG>`

Call git.

### `./studio npm <ARG>`

Call npm.

### `./studio npx <ARG>`

Call npx.

### `./studio serve`

Start http-server and send contents on `./dist` directory.

Call this after running `./studio generate`

## FAQ

### My PC is Windows. Does `nuxt-dev-studio` support Windows?

Unfortunately, not.<br>
Well, if you need one, please open a issue or send a pull request to me.<br>
I'll work for it.

### Container image `kulikala/nuxt-dev-studio` seems not contain `/bin/bash`. What can I do?

The base image is `node:12-alpine`.<br>
Alpine Linux is shipped with `ash` instead of `bash`.

`sh` command will do most of your work.

### I want to use TypeScript like: `<​script lang="ts">`. What can I do?

  Nuxt.js with TypeScript support is separated from its initial configuration currently.<br>
  See: [https://nuxtjs.org/guide/typescript](https://nuxtjs.org/guide/typescript).

  Well, according to the Nuxt.js team article, TypeScript integration is proceeding.<br>
  I'll keep me up to date.

## License

`nuxt-dev-studio` is made available under the terms of the MIT license.
