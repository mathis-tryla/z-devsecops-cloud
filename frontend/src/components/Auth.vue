<template>
    <HelloWorld class="hello-world"></HelloWorld>
    <Form class="auth-form"></Form>
</template>

<script>
import Form from './Form.vue';
import HelloWorld from './HelloWorld.vue';

export default {
  components: {
    Form, HelloWorld
  }
}
</script>

<style>
.container {
    display: flex;
    flex-direction: column;
}

.hello-world {
    order: -1;
    width: 100%;
}

.auth-form {
    order: 1;
}
</style>