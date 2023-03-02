<script>
import axios from 'axios';
import { reactive } from 'vue'

export default {
  setup() {
    const state = reactive({ msg: '' })
    axios
        .get(`http://localhost:3000/api/hello`)
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