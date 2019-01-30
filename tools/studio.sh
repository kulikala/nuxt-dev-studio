#!/bin/ash

TOOLS_DIR=/tools
TEMPLATES_DIR=/templates

TEMPLATE_VUE=${TOOLS_DIR}/template.vue.sh
TEMPLATE_STORE=${TOOLS_DIR}/store.js.sh

RC_FILE=.studiorc

COMMAND="$1"
shift 1

usage () {
  cat << EOS 2>&1
Usage: COMMAND

COMMAND:
  add components|layouts|pages|store NAME
    Add template component, layout, page, or store.

  create NAME
    Initialize given directory with nuxt template.

  git ARG
    Call git.

  install PRE_PROCESSOR
    Install pre-processors.
    Type \`install help\` to show available pre-processors.

  npm ARG
    Call npm.

  npx ARG
    Call npx.

  sh, ash, bash
    Call ash.

  help
    Show this help.

EOS
  exit 1
}

do_add () {
  local TARGET="$1"
  local NAME="$2"
  local SOURCE
  local GENERATED

  case "${TARGET}" in
    component | components)
      SOURCE="${TEMPLATE_VUE}"
      GENERATED="components/${NAME:-MyComponent}.vue"
      ;;
    layout | layouts)
      SOURCE="${TEMPLATE_VUE}"
      GENERATED="layouts/${NAME:-new_layout}.vue"
      ;;
    page | pages)
      SOURCE="${TEMPLATE_VUE}"
      GENERATED="pages/${NAME:-new_page}.vue"
      ;;
    store)
      SOURCE="${TEMPLATE_STORE}"
      GENERATED="store/${NAME:-index}.js"
      ;;
    *)
      echo "Unrecognizable option -- '$(echo "${TARGET}" | sed 's/^-*//')'" 1>&2
      exit 1
      ;;
  esac

  if [ -e "${GENERATED}" ]; then
    echo "File exists: ${GENERATED}" 1>&2
    exit 1
  fi

  (
    if [ -f "${RC_FILE}" ]; then
      . "${RC_FILE}"
    fi
    sh "${SOURCE}" > "${GENERATED}"
  )

  echo "${TARGET} generated: ${GENERATED}"
}

do_create () {
  npx create-nuxt-app \
    "${PROJECT_NAME}"
}

copy_templates () {
  cp -r \
    ${TEMPLATES_DIR}/* \
    "./${PROJECT_NAME}"
}

do_install () {
  local PCKGS
  local DEPENDENCIES_OPT='--save-dev'
  local USAGE
  local TEMPLATE_LANG
  local SCRIPT_LANG
  local STYLE_LANG
  local BUILD_EXTRA

  for OPT in "$@"; do
    case "${OPT}" in
      coffee)
        PCKGS="${PCKGS} coffeescript coffee-loader"
        USAGE="${USAGE}:<script lang=\"coffee\">"
        SCRIPT_LANG=coffee
        BUILD_EXTRA=$(cat << EOS
      config.module.rules.push({
        test: /\.coffee$/,
        use: 'coffee-loader',
        exclude: /(node_modules)/
      })
${BUILD_EXTRA}
EOS
        )
        shift 1
        ;;
      less)
        PCKGS="${PCKGS} less less-loader"
        USAGE="${USAGE}:<style lang=\"less\">"
        STYLE_LANG=less
        shift 1
        ;;
      pug | jade)
        PCKGS="${PCKGS} pug pug-plain-loader"
        USAGE="${USAGE}:<template lang=\"pug\">"
        TEMPLATE_LANG=pug
        shift 1
        ;;
      sass | scss)
        PCKGS="${PCKGS} node-sass sass-loader"
        USAGE="${USAGE}:<style lang=\"$1\">"
        STYLE_LANG="$1"
        shift 1
        ;;
      stylus)
        PCKGS="${PCKGS} stylus stylus-loader"
        USAGE="${USAGE}:<style lang=\"stylus\">"
        STYLE_LANG=stylus
        shift 1
        ;;
      -D | --save-dev | --dev)
        DEPENDENCIES_OPT='--save-dev'
        shift 1
        ;;
      -S | --save)
        DEPENDENCIES_OPT='--save'
        shift 1
        ;;
      help)
        cat << EOS 2>&1
For <template lang="****">
  install pug

For <script lang="****">
  install coffee

For <style lang="****">
  install less
  install sass|scss
  install stylus

EOS
        exit 1
        ;;
      *)
        echo "Unrecognizable option -- '$(echo "$1" | sed 's/^-*//')'" 1>&2
        exit 1
        ;;
    esac
  done

  npm install ${PCKGS} ${DEPENDENCIES_OPT}

  echo 'Pre-processors have been installed.'
  echo
  echo 'Usage:'

  local IFS_ORIG="${IFS}"
  IFS=:

  for LINE in ${USAGE}; do
    if [ "${LINE}" != "" ]; then
      echo "  ${LINE}"
    fi
  done

  IFS="${IFS_ORIG}"

  if [ "${BUILD_EXTRA}" != "" ]; then
    echo
    echo 'Add following lines in extend(config, ctx) block in nuxt.config.js:'
    echo
    echo "${BUILD_EXTRA}"
    echo
  fi

  if [ "${TEMPLATE_LANG:-}" != "" ]; then
    out_studio_rc TEMPLATE_LANG "${TEMPLATE_LANG}"
  fi
  if [ "${SCRIPT_LANG:-}" != "" ]; then
    out_studio_rc SCRIPT_LANG "${SCRIPT_LANG}"
  fi
  if [ "${STYLE_LANG:-}" != "" ]; then
    out_studio_rc STYLE_LANG "${STYLE_LANG}"
  fi
}

out_studio_rc () {
  local KEY="$1"
  local VALUE="$2"

  if [ -f "${RC_FILE}" ] && grep -q -E -e "^\\s*${KEY}=" "${RC_FILE}"; then
    sed -i -E -e "s/^(\\s*${KEY}=.*)\$/#\\1/g" "${RC_FILE}"
  fi

  echo "export ${KEY}=${VALUE}" >> "${RC_FILE}"
}

case "${COMMAND}" in
  help | -h | --help)
    usage
    ;;
  add)
    do_add "$@"
    ;;
  create)
    PROJECT_NAME="${1#/}"
    do_create \
      && copy_templates
    ;;
  git)
    git "$@"
    ;;
  install)
    do_install "$@"
    ;;
  npm)
    npm "$@"
    ;;
  npx)
    npx "$@"
    ;;
  sh | ash | bash)
    sh "$@"
    ;;
  *)
    BIN_CMD="./node_modules/.bin/${COMMAND}"
    if [ -f "${BIN_CMD}" ]; then
      "${BIN_CMD}" "$@"
    else
      usage
    fi
    ;;
esac
