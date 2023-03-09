<template>
    <div class="container">
        <HelloWorld class="hello-world"/>
        <Form class="auth-form"/>
    </div>
</template>

<script setup>
import HelloWorld from './components/HelloWorld.vue'
import Form from './components/Form.vue'
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