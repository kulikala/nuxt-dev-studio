#!/bin/ash

if [ "${SCRIPT_LANG:-}" = "coffee" ]; then
  cat << EOS
export actions = {
}

export getters = {
}

export mutations = {
}

export state = () ->
EOS
else
  cat << EOS
export const actions = {
}

export const getters = {
}

export const mutations = {
}

export const state = () => ({
})
EOS
fi
