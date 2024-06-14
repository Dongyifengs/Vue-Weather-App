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
            <span>{{ weather.temperature }}°</span>
          </div>
          <div class="maxAndMin">
            <span>{{ weather.weather }}</span>
            <span>最高{{weather.high}}°C</span>
            <span>最低{{weather.low}}°C</span>
          </div>
          <div class="fillet">
            <div class="rainPopUpWindow">
              14公里外正在下雨
            </div>
            <div class="airQuality">
              {{weather.aqiLevel}} {{weather.aqi}}
            </div>
          </div>
        </div>
        <div>这里为测试窗口 后续开发完毕删除即可</div>
        <el-button type="primary" @click="toggleDivs">隐藏/显示</el-button>
<!--        <span>{{ locationData }}</span>-->
        <div>天气数据</div>
        地区编号：{{ locationData.adcode }}
        市区：{{ locationData.city }}
        空气湿度：{{ weather.humidity }}
<!--        空气湿度小数点：{{ weatherData.humidity_float }}-->
        省：{{ locationData.province }}
        更新时间：{{ weather.reportTime }}
        实时温度：{{ weather.temperature }}
<!--        实时温度小数点：{{ weatherData.temperature_float }}-->
        天气：{{ weather.weather }}
        风向：{{ weather.windDirection }}
        风速：{{ weather.windPower }}
        <br>
        <el-select-v2 :options="cities" v-model="cityCode" filterable placeholder="请选择城市" @change="changeCity" style="width: 200px" />

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
            <el-table-column prop="ymd" label="Date" width="120px"/>
            <el-table-column prop="type" label="Weather"/>
            <el-table-column prop="fx" label="Wind Direction"/>
            <el-table-column prop="aqi" label="Tag"/>
            <el-table-column prop="type" label="Weather Icon"/>
            <el-table-column prop="high" label="Temperature"/>
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
import {onMounted, ref} from "vue";
import {More, Plus} from "@element-plus/icons-vue";
import { ElSelectV2 } from 'element-plus'

import "./index.css";
import {CurrentWeatherData, ForeCaseData, getAqiLevel} from "../../entities/WeatherData.ts";
import {getCities, getWeather} from "../../api";

const tableData = ref<ForeCaseData[]>([]);
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
const weather = ref<CurrentWeatherData>({humidity: 0, reportTime: "", temperature: 0, weather: "", windDirection: "", windPower: 0, high: 0, low: 0, aqi: 0, aqiLevel: "优"});
/*let weatherData = ref({
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
});*/

/*const getLocation = async () => {
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
};*/

/*const getWeather = async (adcode: string) => {
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

};*/

const moreWeather = async () => {
  console.log(123)
}
const cities = ref<{value: number, label: string}[]>([]);
const cityCode = ref<number>();
onMounted(async () => {
  for (let data of (await getCities()).data) {
    cities.value.push({value: data.code, label: data.name});
  }
});


const toggleDivs = () => {
  const warningDiv = document.querySelector('.warning') as HTMLElement;
  const rainChartDiv = document.querySelector('.rainLineChart') as HTMLElement;
  if (warningDiv && rainChartDiv) {
    warningDiv.style.display = warningDiv.style.display === 'none' ? 'block' : 'none';
    rainChartDiv.style.display = rainChartDiv.style.display === 'none' ? 'block' : 'none';
  }
};
const fetchWeatherData = async () => {
  if (cityCode.value){
    const weatherResponse = await getWeather(cityCode.value);
    const responseData = weatherResponse.data;
    const todayForecastData = responseData.data.forecast[0];
    weather.value.reportTime = responseData.time;
    weather.value.weather = todayForecastData.type;
    weather.value.humidity = Number.parseInt(responseData.data.shidu.replace("%", ""));
    weather.value.temperature = Number.parseFloat(responseData.data.wendu);
    weather.value.windDirection = todayForecastData.fx;
    weather.value.windPower = Number.parseFloat(todayForecastData.fl);
    weather.value.high = Number.parseFloat(todayForecastData.high.split(" ")[1].replace("℃", ""));
    weather.value.low = Number.parseFloat(todayForecastData.low.split(" ")[1].replace("℃", ""));
    const aqi = Number.parseFloat(todayForecastData.aqi);
    weather.value.aqi = aqi;
    weather.value.aqiLevel = getAqiLevel(aqi);
    while(tableData.value.length !== 0) {
      tableData.value.pop();
    }
    for (let forecastElement of responseData.data.forecast.splice(0, 5)) {
      tableData.value.push(forecastElement);
    }
  }
}
const changeCity = () => {
  fetchWeatherData();
}
</script>


<style scoped>

</style>
