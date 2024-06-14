<!-- moyi and wzp -->
<template>
  <div class="homePage">
    <el-header class="head">
      <div class="headIcon">
        <div class="headIconSvg">
          <el-icon>
            <Plus/>
          </el-icon>
        </div>
        <div class="headIconSvg">
          <el-icon>
            <More/>
          </el-icon>
        </div>
      </div>
    </el-header>

    <el-container class="container">
      <el-aside class="weatherPage">
        <div class="weatherConditions">
          <div class="location">
            <span class="province"> {{ locationData.province }} </span>
            <span class="city"> {{ locationData.city }} </span>
          </div>
          <div class="temperature">
            <span>{{ weatherData.temperature }}°</span>
          </div>
          <div class="maxAndMin">
            <span>{{ weatherData.weather }}</span>
            <span>最高22°</span>
            <span>最低16°</span>
          </div>
          <div class="fillet">
            <div class="rainPopUpWindow">
              14公里外正在下雨
            </div>
            <div class="airQuality">
              空气优 26
            </div>
          </div>
        </div>
        <div>这里为测试窗口 后续开发完毕删除即可</div>
        <el-button type="primary" @click="toggleDivs">隐藏/显示</el-button>
        <span>{{ locationData }}</span>
        <div>天气数据</div>
        地区编号：{{ weatherData.adcode }}
        市区：{{ weatherData.city }}
        空气湿度：{{ weatherData.humidity }}
        空气湿度小数点：{{ weatherData.humidity_float }}
        省：{{ weatherData.province }}
        更新时间：{{ weatherData.reporttime }}
        实时温度：{{ weatherData.temperature }}
        实时温度小数点：{{ weatherData.temperature_float }}
        天气：{{ weatherData.weather }}
        风向：{{ weatherData.winddirection }}
        风速：{{ weatherData.windpower }}
        <br>
        <el-select-v2 :options="cities" v-model="cityCode" filterable placeholder="请选择城市" />

      </el-aside>

      <el-main class="dataPage">
        <div class="warning">
          警告：当前无警告 - 【测试开发，无警告隐藏】
        </div>
        <div class="rainLineChart">
          当前是下雨2小时预计折线图 - 【正在开发】
        </div>
        <div class="futureForecast">
          当前是未来5天天气预测
          <el-table :data="tableData" :show-header="false" class="el-table">
            <el-table-column prop="time" label="Date"/>
            <el-table-column prop="weather" label="Weather"/>
            <el-table-column prop="windDirection" label="Wind Direction"/>
            <el-table-column prop="tag" label="Tag"/>
            <el-table-column prop="weatherIcon" label="Weather Icon"/>
            <el-table-column prop="temperature" label="Temperature"/>
          </el-table>
          <div class="moreWeather">
            <el-button type="primary" @click="moreWeather">查看未来15日天气</el-button>
          </div>
        </div>
        <div class="hourLineChart">
          当前是预计24小时天气（精准到小时） - 【正在开发】
        </div>
        <div class="dataPageAbout">
          <div class="dataPageAboutSection">
            <div class="ultraviolet">
              紫外线：弱
            </div>
            <div class="windDirection">
              风向：北风 1级
            </div>
            <div class="sunset">
              日落：19：19
            </div>
          </div>
          <div class="dataPageAboutSection">
            <div class="humidity">
              湿度：75%
            </div>
            <div class="somatosensory">
              体感：19°
            </div>
            <div class="airPressure">
              气压：1000
            </div>
          </div>
        </div>
        <div class="videoCctv">
          央视天气预报视频播放 - 点击播放当天央视天气预报报道
        </div>
        <div class="recommend">
          <div class="recommendSection">
            <div>适宜短袖</div>
            <div>注意防晒</div>
            <div>宜室内运动</div>
          </div>
          <div class="recommendSection">
            <div>不宜洗车</div>
            <div>有雨带伞</div>
            <div>少发感冒</div>
          </div>
        </div>
      </el-main>
    </el-container>
  </div>
</template>

<script setup lang="ts">
import {onMounted, ref, computed} from "vue";
import {More, Plus} from "@element-plus/icons-vue";
import { ElSelectV2 } from 'element-plus'

import "./css/PCVersion.css";

const tableData = [
  {
    time: '今天',
    weather: '多云',
    windDirection: '东北风二级',
    tag: '良',
    weatherIcon: '多云图标',
    temperature: '18-25'
  },
  {
    time: '明天',
    weather: '小雨',
    windDirection: '西南风三级',
    tag: '轻度污染',
    weatherIcon: '小雨图标',
    temperature: '15-20'
  },
  {time: '后天', weather: '晴', windDirection: '东风一级', tag: '优', weatherIcon: '晴天图标', temperature: '17-23'},
  {
    time: '大后天',
    weather: '雷阵雨',
    windDirection: '南风四级',
    tag: '中度污染',
    weatherIcon: '雷阵雨图标',
    temperature: '20-24'
  },
  {
    time: '周六',
    weather: '阴转小雨',
    windDirection: '西北风二级',
    tag: '良',
    weatherIcon: '阴转小雨图标',
    temperature: '14-21'
  }
];
// 位置信息
let locationData = ref({
  status: '',
  info: '',
  infocode: '',
  province: '',
  city: '',
  adcode: '',
  rectangle: ''
});

// 天气信息
let weatherData = ref({
  adcode: "",
  city: "",
  humidity: "",
  humidity_float: "",
  province: "",
  reporttime: "",
  temperature: "",
  temperature_float: "",
  weather: "",
  winddirection: "",
  windpower: ""
});

const apiKey = import.meta.env.VITE_AMAP_API_KEY;

const getLocation = async () => {
  const response = await fetch(`https://restapi.amap.com/v3/ip?key=${apiKey}`);
  if (!response.ok) {
    throw new Error(`HTTP error! status: ${response.status}`);
  }
  const data = await response.json();
  locationData.value = {
    status: data.status || '获取返回状态失败',
    info: data.info || '获取信息失败',
    infocode: data.infocode || 'NULL',
    province: data.province || 'XX省',
    city: data.city || 'XX市',
    adcode: data.adcode || 'NULL',
    rectangle: data.rectangle || 'NULL'
  };

  console.log(locationData.value); // 在此打印 locationData 确认 adcode
};

const getWeather = async (adcode: string) => {
  if (!adcode) {
    console.error('adcode is empty');
    return;
  }
  const response = await fetch(`https://restapi.amap.com/v3/weather/weatherInfo?city=${adcode}&key=${apiKey}`);
  if (!response.ok) {
    throw new Error(`HTTP error! status: ${response.status}`);
  }
  const dataJson = await response.json();
  const data = dataJson.lives[0];
  weatherData.value = {
    adcode: data.status || 'NULL',
    city: data.city || 'XX市',
    humidity: data.humidity || 'NULL',
    humidity_float: data.humidity_float || 'NULL',
    province: data.province || 'XX省',
    reporttime: data.reporttime || 'NULL',
    temperature: data.temperature || 'NULL',
    temperature_float: data.temperature_float || 'NULL',
    weather: data.weather || 'NULL',
    winddirection: data.winddirection || 'NULL',
    windpower: data.windpower || 'NULL',
  }

};

const moreWeather = async () => {
  console.log(123)
}
const cities = ref<Record<string, string>[]>([]);
const cityCode = ref<string>("");
onMounted(async () => {
  // 先让getLocation执行
  await getLocation();
  // 获取天气情况（参数是地区编号） -> 安徽省 宿州市
  getWeather(locationData.value.adcode);
  const response = await fetch("/citycode.json");
  const data = await response.json();
  data.map((e) => {
    if (e.city_code){
      cities.value.push({value: e.city_code, label: e.city_name});
    }
  });
});


const toggleDivs = () => {
  const warningDiv = document.querySelector('.warning') as HTMLElement;
  const rainChartDiv = document.querySelector('.rainLineChart') as HTMLElement;
  if (warningDiv && rainChartDiv) {
    warningDiv.style.display = warningDiv.style.display === 'none' ? 'block' : 'none';
    rainChartDiv.style.display = rainChartDiv.style.display === 'none' ? 'block' : 'none';
  }
};
</script>


<style scoped>

</style>
