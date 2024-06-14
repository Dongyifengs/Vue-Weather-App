<template>
  <div v-if="weatherStatus.status === '200'">
    <h1>天气信息 - {{ weatherStatus.cityInfo.city }}</h1>
    <p>更新时间：{{ weatherStatus.cityInfo.updateTime }}</p>
    <p>当前温度：{{ weatherStatus.data.wendu }}°C</p>
    <p>湿度：{{ weatherStatus.data.shidu }}</p>
    <p>空气质量：{{ weatherStatus.data.quality }} (PM2.5: {{ weatherStatus.data.pm25 }}, PM10: {{ weatherStatus.data.pm10 }})</p>
    <h2>未来几日天气预报：</h2>
    <ul>
      <li v-for="forecast in weatherStatus.data.forecast" :key="forecast.date">
        {{ forecast.ymd }} - {{ forecast.type }} 最高温度 {{ forecast.high }}, 最低温度 {{ forecast.low }}
      </li>
    </ul>
  </div>
  <p v-else>无法获取天气数据，请检查API或网络连接。</p>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';

const weatherStatus = ref({
  status: '',  // 状态码：200 表示数据成功获取，404 表示未找到指定城市
  cityInfo: {  // 城市信息部分
    city: '',  // 城市全名
    cityKey: '',  // 城市的唯一标识码
    parent: '',  // 上级行政区划，通常是省份或直辖市
    updateTime: ''  // 数据最后更新时间
  },
  data: {  // 天气相关数据
    shidu: '',  // 相对湿度
    pm25: '',  // PM2.5值
    pm10: '',  // PM10值
    quality: '',  // 空气质量描述
    wendu: '',  // 当前温度
    ganmao: '',  // 感冒指数描述
    forecast: []  // 未来天气预报数组
  }
});

const getLocation = async () => {
  const response = await fetch(`/api/api/weather/city/101010100`);
  const data = await response.json();
  if (response.ok && data.status === 200) {
    weatherStatus.value = {
      status: data.status.toString(),  // 确保是字符串
      cityInfo: {
        city: data.cityInfo.city,
        cityKey: data.cityInfo.citykey,
        parent: data.cityInfo.parent,
        updateTime: data.cityInfo.updateTime
      },
      data: {
        shidu: data.data.shidu,
        pm25: data.data.pm25.toString(),
        pm10: data.data.pm10.toString(),
        quality: data.data.quality,
        wendu: data.data.wendu,
        ganmao: data.data.ganmao,
        forecast: data.data.forecast
      }
    };
  } else {
    throw new Error(`获取数据失败，状态码：${data.status}`);
  }
};


onMounted(async () => {
  try {
    await getLocation();
  } catch (error) {
    console.error('获取天气数据失败:', error.message);
    // 此处可以设置一个状态，用于在模板中显示错误消息
  }
});
</script>


<style scoped>
* {
  color: #7f8a9c;
}

h1, p {
  font-family: Arial, sans-serif;
}

ul {
  list-style-type: none;
  padding: 0;
}
</style>
