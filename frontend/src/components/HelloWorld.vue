<script>
import axios from 'axios';
import { reactive } from 'vue'

export default {
  data() {
    const state = reactive({ msg: '' })
    axios
        .get(`/api/hello`)
        .then((res) => state.msg = res.data)
    return {
      state
    }
  }
}
</script>

<template>
    <h1>{{ state.msg }}</h1>
</template>

<style>
h1 {
    color: black;
    margin-right: 20%;
}
</style>