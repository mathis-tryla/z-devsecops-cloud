<template>
    <HelloWorld />
    <Form />
</template>

<script>
import HelloWorld from './components/HelloWorld.vue'
import Form from './components/Form.vue'

export default {
  name: 'App',
  components: {
    HelloWorld, Form
  }
}
</script>