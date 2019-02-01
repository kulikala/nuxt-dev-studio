#/bin/ash

out_template () {
  cat << EOS
<template${TEMPLATE_LANG:+ lang="${TEMPLATE_LANG}"}>
</template>
EOS
}

out_script () {
  echo
  echo "<script${SCRIPT_LANG:+ lang=\"${SCRIPT_LANG}\"}>"

  if [ -z "${SCRIPT_LANG:-}" ]; then
    if [ -z "${SCRIPT_IMPORT:-}" ]; then
      cat << EOS
export default {
  data: () => ({
  })
}
EOS
    else
      cat << EOS
import MyComponent from '~/components/MyComponent'

export default {
  components: {
    MyComponent
  },

  data: () => ({
  })
}
EOS
    fi
  elif [ "${SCRIPT_LANG:-}" = "coffee" ]; then
    cat << EOS
export default
  data: () ->
EOS
  fi

  echo "</script>"
}

out_style () {
  cat << EOS

<style${STYLE_LANG:+ lang="${STYLE_LANG}"}>
</style>
EOS
}

out_template
out_script
out_style
