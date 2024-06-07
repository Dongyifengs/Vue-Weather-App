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
          <div class="temperature">
            <span>20°</span>
          </div>
          <div class="maxAndMin">
            <span>阴</span>
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
        <el-button type="primary" @click="toggleDivs">隐藏/显示</el-button>
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
import {More, Plus} from "@element-plus/icons-vue";

// 天气数据
const tableData = [
  {
    time: '今天',
    weather: '多云',
    windDirection: '东北风二级',
    Tag: '良',
    weatherIcon: '多云图标',
    temperature: '18-25'
  },
  {
    time: '明天',
    weather: '小雨',
    windDirection: '西南风三级',
    Tag: '轻度污染',
    weatherIcon: '小雨图标',
    temperature: '15-20'
  },
  {
    time: '后天',
    weather: '晴',
    windDirection: '东风一级',
    Tag: '优',
    weatherIcon: '晴天图标',
    temperature: '17-23'
  },
  {
    time: '大后天',
    weather: '雷阵雨',
    windDirection: '南风四级',
    Tag: '中度污染',
    weatherIcon: '雷阵雨图标',
    temperature: '20-24'
  },
  {
    time: '周六',
    weather: '阴转小雨',
    windDirection: '西北风二级',
    Tag: '良',
    weatherIcon: '阴转小雨图标',
    temperature: '14-21'
  }
]

const toggleDivs = () => {
  const warningDiv = document.querySelector('.warning') as HTMLElement;
  const rainChartDiv = document.querySelector('.rainLineChart') as HTMLElement;
  if (warningDiv && rainChartDiv) {
    warningDiv.style.display = warningDiv.style.display === 'none' ? 'block' : 'none';
    rainChartDiv.style.display = rainChartDiv.style.display === 'none' ? 'block' : 'none';
  }
}

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
  margin: 10px 0 0 0 ;
  --el-table-border-color: none;
  --el-table-bg-color: transparent;
  --el-table-tr-bg-color: transparent;
  --el-table-text-color: #fff;
  --el-table-row-hover-bg-color: rgba(255,255,255,0.2);
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
  background-color: rgba(255,255,255,0.1);
  padding: 10px;
  margin: 0 10px 0 0;
}

.weatherConditions > .fillet > .airQuality {
  width: 15%;
}
</style>
