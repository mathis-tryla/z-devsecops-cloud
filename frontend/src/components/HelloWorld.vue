<template>
    <h1>{{ msg }}</h1>
</template>

<script>
export default {
  name: 'HelloWorld',
  data() {
    return {
        msg: ''
    }
  },
  mounted() {
    fetch('/hello')
    .then(res => res.text())
    .then(data => {
        this.msg = data;
    })
  }
}
</script>