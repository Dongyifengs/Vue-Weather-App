<template>
  <Component :is="obj"></Component>
</template>
<script lang="ts" setup>
import {markRaw, onBeforeMount, ref} from "vue";
import Main from "./views/Main.vue";
import Test from "./views/Test.vue";
const obj = ref(markRaw(Main));
onBeforeMount((e) => {
  if (window.location.href.endsWith("test")) {
    obj.value = markRaw(Test);
  }
})
</script>
<style>

</style>