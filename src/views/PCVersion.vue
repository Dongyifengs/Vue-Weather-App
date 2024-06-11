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

      </el-aside>

      <el-main class="dataPage">
        <div class="warning">
          警告：当前无警告 - 【测试开发，无警告隐藏】
        </div>
        <div class="rainLineChart">
          当前是下雨2小时预计折线图 - 【正在开发】
        </div>
        <div class="futureForecast">
          当前是未来15天天气预测
          <el-table :data="tableData" :show-header="false" class="el-table">
            <el-table-column prop="time" label="Date"/>
            <el-table-column prop="weather" label="Weather"/>
            <el-table-column prop="windDirection" label="Wind Direction"/>
            <el-table-column prop="tag" label="Tag"/>
            <el-table-column prop="weatherIcon" label="Weather Icon"/>
            <el-table-column prop="temperature" label="Temperature"/>
          </el-table>
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
  try {
    const response = await fetch(`https://restapi.amap.com/v3/ip?key=${apiKey}`);
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    const data = await response.json();
    locationData.value = {
      status: data.status || 'NULL',
      info: data.info || 'NULL',
      infocode: data.infocode || 'NULL',
      province: data.province || 'XX省',
      city: data.city || 'XX市',
      adcode: data.adcode || 'NULL',
      rectangle: data.rectangle || 'NULL'
    };

    console.log(locationData.value); // 在此打印 locationData 确认 adcode
  } catch (error) {
    console.error('Error:',);
  }
};


const getWeather = async (adcode: string) => {
  if (!adcode) {
    console.error('adcode is empty');
    return;
  }

  try {
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
  } catch (error) {
    console.error('Error:',);
  }
};

onMounted(async () => {
  // 先让getLocation执行
  await getLocation();
  // 获取天气情况（参数是地区编号） -> 安徽省 宿州市
  getWeather(locationData.value.adcode);
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
* {
  margin: 0;
  padding: 0;
  color: #fff;
}

.homePage {
  background-color: #7f8a9c;
}

.head {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: flex-end;
  margin-right: 20px;
}

.headIcon {
  display: flex;
}

.headIconSvg {
  margin: 0 10px;
}

.container {
  height: calc(100vh - 60px);
}

.weatherPage {
  width: 40% !important;
  height: 100%;
}

.dataPage {
  width: 60% !important;
  height: 100%;
}

.dataPage > div:not(.dataPageAbout, .recommend) {
  border-radius: 10px;
  background-color: rgba(255, 255, 255, 0.1);
  padding: 10px;
  margin: 0 60px 20px 20px;
}

.dataPageAbout > div {
  margin: 0 60px 0 0;
  display: flex;
}

.dataPageAbout > div > div {
  border-radius: 10px;
  background-color: rgba(255, 255, 255, 0.1);
  width: 33.33%;
  padding: 10px;
  margin: 0 0 20px 20px;
}

.recommend > div {
  margin: 0 60px 0 0;
  display: flex;
}

.recommend > div > div {
  border-radius: 10px;
  background-color: rgba(255, 255, 255, 0.1);
  width: 33.33%;
  padding: 10px;
  margin: 0 0 20px 20px;
}

.el-table {
  margin: 10px 0 0 0;
  --el-table-border-color: none;
  --el-table-bg-color: transparent;
  --el-table-tr-bg-color: transparent;
  --el-table-text-color: #fff;
  --el-table-row-hover-bg-color: rgba(255, 255, 255, 0.2);
  border-radius: 10px;
}

.el-table__row {
  border-radius: 10px;
}

.weatherConditions {
  margin: 20% 0 0 10%;
}

.weatherConditions > .temperature {
  font-size: 150px;
  margin: 0;
}

.weatherConditions > .maxAndMin > span {
  margin: 0 10px 0 0;
}

.fillet {
  display: flex;
}

.weatherConditions > .fillet > div {
  font-size: 15px;
  width: 27%;
  border-radius: 10px;
  background-color: rgba(255, 255, 255, 0.1);
  padding: 10px;
  margin: 0 10px 0 0;
}

.weatherConditions > .fillet > .airQuality {
  width: 15%;
}
</style>
