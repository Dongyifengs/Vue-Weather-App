<template>
  <div class="weatherBox">
    <!-- 天气APP中上方的信息 -->
    <div class="weatherMainInfo">
      <div class="weatherMainInfoCity">
        <div class="weatherMainInfoCityMyLocation">
          <span class="weatherMainInfoCityMyLocationText">
            我的位置
          </span>
        </div>
        <div class="weatherMainInfoCityName">
          <span class="weatherMainInfoCityNameSpanText">
            {{ AMapLocationDataByLongitudeAndLatitude.township }}
          </span>
        </div>
        <div class="weatherMainInfoCityTemperature">
          <span class="weatherMainInfoCityTemperatureText">
            {{ xiaoMiWeatherData.weatherTemperature }}
          </span>
        </div>
        <div class="weatherMainInfoCityWeather">
          <div class="weatherMainInfoCityWeatherText">
            {{ xiaoMiWeatherData.weather }}
          </div>
        </div>
        <div class="weatherMainInfoCityMinMaxTemperature">
          <span class="weatherMainInfoCityMinMaxTemperatureText">最高{{ xiaoMiWeatherData.maximumTemperature }}</span>
          <span class="weatherMainInfoCityMinMaxTemperatureText">最低{{ xiaoMiWeatherData.minimumTemperature }}</span>
        </div>
      </div>
    </div>

    <!-- 天气APP下方详情数据 -->
    <div class="weatherInfoRainForecastTable">
      <div class="weatherInfoRainForecastTableWeatherSchedule">

        <div class="weatherInfoRainForecastTableWeatherScheduleLabel">
          <span class="weatherInfoRainForecastTableWeatherScheduleLabelText">样式文本</span>
          <el-divider class="weatherInfoRainForecastTableWeatherScheduleLabelDivider"/>
          <div class="weatherInfoRainForecastTableWeatherScheduleLabelBox">
            <div class="weatherInfoRainForecastTableWeatherScheduleLabelWeatherInformation"
                 v-for="item of [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24]">
              <div class="weatherInfoRainForecastTableWeatherScheduleLabelWeatherInformationTime">
                {{ currentTimeData.hour }}:{{ currentTimeData.minute }}
              </div>
              <div class="weatherInfoRainForecastTableWeatherScheduleLabelWeatherInformationIcon">
                <img class="weatherInfoRainForecastTableWeatherScheduleLabelWeatherInformationIconImg"
                     src="/public/WeatherIcon/weather_1.png" alt="晴">
              </div>
              <div class="weatherInfoRainForecastTableWeatherScheduleLabelWeatherInformationTemperature">
                {{ xiaoMiWeatherData.weatherTemperature }}
              </div>
            </div>
          </div>
        </div>


        <div class="weatherInfoRainForecastTableWeatherScheduleTwoBox">


          <div class="weatherInfoRainForecastTableWeatherSchedule_15DayWeatherForecast">
            <div class="weatherInfoRainForecastTableWeatherSchedule_15DayWeatherForecastText">未来15天天气预报</div>
            <el-divider class="weatherInfoRainForecastTableWeatherSchedule_15DayWeatherForecastLabelDivider"/>
            <el-table :data="tableData" :show-header="false" class="el-table">
              <el-table-column prop="ymd" label="Date" width="120px"/>
              <el-table-column prop="type" label="Weather"/>
              <el-table-column prop="fx" label="Wind Direction"/>
              <el-table-column prop="aqi" label="Tag"/>
              <el-table-column prop="type" label="Weather Icon"/>
              <el-table-column prop="high" label="Temperature"/>
            </el-table>
          </div>

          <div class="weatherInfoRainForecastTableWeatherSchedulePrecipitation">
            <div class="weatherInfoRainForecastTableWeatherSchedulePrecipitationText">降水量</div>
            <el-divider class="weatherInfoRainForecastTableWeatherSchedulePrecipitationLabelDivider"/>
          </div>


        </div>


      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import {onMounted, ref} from "vue";

// 定义密钥
const AMapAPIKey = ref('079963952e63e5defc32f95bc45a7113') // 此密钥是支付宝的密钥
const XiaoMiWeatherAPIKey = ref('zUFJoAR2ZVrDy1vF3D07') // 小米天气密钥

// 获取的地理数据
const longitudeInfo = ref('') // 经度
const latitude = ref('') // 纬度
const longitudeAndLongitude = ref('')
const longitudeAndLongitudeEndSix = ref('')
const accuracyInfo = ref('') // 精度

// 高德获取的地理数据
const AMapLocationData = ref({
  status: '', // 返回状态
  info: '', // 获取信息
  infoCode: '', // 状态代码
  province: '', // 地区省份
  city: '', // 地区城市
  adCode: '', // 地区代码
  rectangle: '' // 地区经纬度范围
})

// 高德精度转换数据
const AMapLocationDataByLongitudeAndLatitude = ref({
  formattedAddress: '', // 格式化地址
  province: '', // 省份
  city: '', // 城市
  district: '', // 区县
  township: '', // 街道
})

// 小米天气数据类型定义
const xiaoMiWeatherData = ref({
  weatherTemperature: '', // 天气温度
  maximumTemperature: '', // 最大温度
  minimumTemperature: '', // 最小温度
})

// 时间定义
const currentTimeData = ref({
  year: '', //年
  month: '', //月
  day: '', //日
  hour: '', //时
  minute: '', //分
  second: '', //秒
})

// 获取当前时间
const getCurrentTime = () => {
  const currentTime = new Date();
  const year = currentTime.getFullYear();
  const month = currentTime.getMonth() + 1;
  const day = currentTime.getDate();
  const hour = currentTime.getHours();
  const minute = currentTime.getMinutes().toString().padStart(2, '0');
  const second = currentTime.getSeconds();
  currentTimeData.value = {
    year: year,
    month: month,
    day: day,
    hour: hour,
    minute: minute,
    second: second,
  };
}

// 获取经纬度（傻逼Chrome需要打开 `chrome://flags/` 然后将 `Enable location provider manager for Geolocation API` 更改为  `Enabled PlatformOnly`）
const getLocationLatitudeAndLongitude = async () => {
  await new Promise((resolve, reject) => {
    navigator.geolocation.getCurrentPosition((latitudeAndLongitudeInfo) => {
      // 获取经纬度
      const getLatitudeAndLongitude = latitudeAndLongitudeInfo.coords
      longitudeInfo.value = getLatitudeAndLongitude.longitude
      latitude.value = getLatitudeAndLongitude.latitude
      longitudeAndLongitude.value = getLatitudeAndLongitude.longitude + "," + getLatitudeAndLongitude.latitude
      longitudeAndLongitudeEndSix.value = getLatitudeAndLongitude.longitude.toFixed(6) + "," + getLatitudeAndLongitude.latitude.toFixed(6)
      accuracyInfo.value = getLatitudeAndLongitude.accuracy;
      // 日志输出
      console.log("经纬度如下信息：");
      console.log("经度：" + getLatitudeAndLongitude.longitude)
      console.log("维度：" + getLatitudeAndLongitude.latitude)
      console.log("经度纬度：" + getLatitudeAndLongitude.longitude + "," + getLatitudeAndLongitude.latitude)
      console.log("精度：" + getLatitudeAndLongitude.accuracy + "米")
      resolve();
    }, (latitudeAndLongitudeInfoError) => {
      console.log(latitudeAndLongitudeInfoError)
      reject(latitudeAndLongitudeInfoError);
    }, {
      enableHighAccuracy: true,
      timeout: 5000, // 增加超时处理
      maximumAge: 0 // 确保每次都获取最新的位置信息
    })
  });
}

// 获取位置[高德地图API]
const getLocationAMapInfo = async () => {
  const AMapAPI = await fetch(`https://restapi.amap.com/v3/ip?key=${AMapAPIKey.value}`)
  if (!AMapAPI.ok) {
    throw new Error(`网络错误: ${AMapAPI.status}`)
  }
  const AMapLocationDataInfo = await AMapAPI.json();
  AMapLocationData.value = {
    status: AMapLocationDataInfo.status || '获取返回状态失败',
    info: AMapLocationDataInfo.info || '获取信息失败',
    infoCode: AMapLocationDataInfo.infocode || '未获取到状态代码',
    province: AMapLocationDataInfo.province || '未获取到省份',
    city: AMapLocationDataInfo.city || '未获取到市区',
    adCode: AMapLocationDataInfo.adcode || '未获取到城市代码',
    rectangle: AMapLocationDataInfo.rectangle || '未获取到经纬度范围'
  };
  console.log('获取位置[高德地图API]如下信息:');
  console.log(JSON.stringify(AMapLocationData.value))
}

// 经纬度转换[高德地图API]
const getLocationAMapInfoByLongitudeAndLatitude = async () => {
  const AMapAPIUrl = new URL('https://restapi.amap.com/v3/geocode/regeo');
  AMapAPIUrl.searchParams.set('output', 'json')
  AMapAPIUrl.searchParams.set('location', longitudeAndLongitudeEndSix.value)
  AMapAPIUrl.searchParams.set('key', AMapAPIKey.value)
  AMapAPIUrl.searchParams.set('radius', 200)
  AMapAPIUrl.searchParams.set('extensions', 'all')
  const AMapAPI = await fetch(AMapAPIUrl)
  if (!AMapAPI.ok) {
    throw new Error(`网络错误: ${AMapAPI.status}`)
  }
  const AMapLocationDataInfo = await AMapAPI.json();
  const getTranslationAddress = AMapLocationDataInfo.regeocode.addressComponent
  AMapLocationDataByLongitudeAndLatitude.value = {
    formattedAddress: AMapLocationDataInfo.regeocode.formatted_address || '未获取到格式化地址',
    province: getTranslationAddress.province || '未获取到省份',
    city: getTranslationAddress.city || '未获取到市区',
    district: getTranslationAddress.district || '未获取到区县',
    township: getTranslationAddress.township || '未获取到街道'
  };
  console.log('经纬度转换[高德地图API]如下信息:');
  console.log(JSON.stringify(AMapLocationDataByLongitudeAndLatitude.value))
}

// 获取天气信息[小米API]
const getWeatherInformation = async () => {
  const XiaoMiAPIUrl = new URL('/api/mi/weather/all', window.location.href)
  XiaoMiAPIUrl.searchParams.set('latitude', latitude.value)
  XiaoMiAPIUrl.searchParams.set('longitude', longitudeInfo.value)
  XiaoMiAPIUrl.searchParams.set('isLocated', 'true')
  XiaoMiAPIUrl.searchParams.set('days', '15')
  XiaoMiAPIUrl.searchParams.set('appKey', 'weather20151024')
  XiaoMiAPIUrl.searchParams.set('sign', XiaoMiWeatherAPIKey.value)
  XiaoMiAPIUrl.searchParams.set('romVersion', '7.2.16')
  XiaoMiAPIUrl.searchParams.set('appVersion', '87')
  XiaoMiAPIUrl.searchParams.set('alpha', 'false')
  XiaoMiAPIUrl.searchParams.set('isGlobal', 'false')
  XiaoMiAPIUrl.searchParams.set('device', 'cancro')
  XiaoMiAPIUrl.searchParams.set('locale', 'zh_cn')
  const XiaoMiAPI = await fetch(XiaoMiAPIUrl)
  if (!XiaoMiAPI.ok) {
    throw new Error(`网络错误: ${XiaoMiAPI.status}`)
  }
  const xiaoMiWeatherDataInfo = await XiaoMiAPI.json();
  xiaoMiWeatherData.value = {
    weatherTemperature: xiaoMiWeatherDataInfo.current.temperature.value + '°' || '未获取到温度',
    maximumTemperature: xiaoMiWeatherDataInfo.yesterday.tempMax + '°',
    minimumTemperature: xiaoMiWeatherDataInfo.yesterday.tempMin + '°' || '未获取到最低温度'
  };
  console.log('获取天气信息[小米API]如下信息:');
  console.log(JSON.stringify(xiaoMiWeatherData.value))
}

onMounted(async () => {
  // 获取当前时间
  getCurrentTime()
  // 获取经纬度[本地使用硬件]
  await getLocationLatitudeAndLongitude()
  // 高德API获取位置信息
  await getLocationAMapInfo()
  // 经纬度转换[高德地图API]
  await getLocationAMapInfoByLongitudeAndLatitude()
  // 获取天气信息[小米API]
  await getWeatherInformation()
})


</script>

<style scoped>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

.weatherBox {
  width: 100%;
  min-height: 100vh; /* 使用视口高度填满页面 */
  background-color: #70a7e0;
}

.weatherMainInfoCity {
  background-color: pink;
  display: flex;
  justify-content: center;
  align-items: center;
  margin-bottom: 20px;
  padding: 10px;
  text-align: center;
  flex-direction: column
}

.weatherInfoRainForecastTableWeatherScheduleLabel {
  width: calc(100% - 30px);
  margin: 0 auto;
  border-radius: 10px;
  background-color: rgba(255, 255, 255, 0.1);
  padding: 5px 10px 5px 10px;
  color: #fff;
  font-size: 14px;
}

.weatherInfoRainForecastTableWeatherSchedule_15DayWeatherForecast {
  width: calc(50% - 10px);
  border-radius: 10px;
  background-color: rgba(255, 255, 255, 0.1);
  padding: 5px 10px 5px 10px;
  color: #fff;
  font-size: 14px;
}

.weatherInfoRainForecastTableWeatherSchedulePrecipitation {
  width: calc(50% - 10px);
  border-radius: 10px;
  background-color: rgba(255, 255, 255, 0.1);
  padding: 5px 10px 5px 10px;
  color: #fff;
  font-size: 14px;
}

.weatherInfoRainForecastTableWeatherScheduleLabelDivider {
  margin: 5px 0;
}

.weatherInfoRainForecastTableWeatherScheduleLabelWeatherInformation {
  background-color: pink;
  width: 100px; /* 调整宽度以适应移动端 */
  padding: 10px;
  display: inline-block; /* 确保在横向滚动时内容水平排列 */
  border-radius: 10px;
  margin: 0 2px;
  text-align: center; /* 内容居中 */
}

.weatherInfoRainForecastTableWeatherScheduleLabelBox::-webkit-scrollbar {
  display: none;
}

.weatherInfoRainForecastTableWeatherScheduleLabelWeatherInformation > * {
  margin: 2px 0 2px 0;
}

.weatherInfoRainForecastTableWeatherScheduleLabelWeatherInformationIconImg {
  height: 30px;
}

.weatherInfoRainForecastTableWeatherScheduleLabelBox {
  display: flex;
  overflow-x: auto;
  white-space: nowrap;
  padding-bottom: 10px;
  -ms-overflow-style: none;
}

.el-table {
  margin: 10px 0 0 0;
  --el-table-border-color: rgba(255, 255, 255, 0.1);
  --el-table-bg-color: transparent;
  --el-table-tr-bg-color: transparent;
  --el-table-text-color: #fff;
  --el-table-row-hover-bg-color: rgba(255, 255, 255, 0.2);
  border-radius: 10px;
}

.weatherInfoRainForecastTableWeatherSchedule > div {
  margin-top: 15px;
}

.weatherInfoRainForecastTableWeatherScheduleTwoBox {
  width: calc(100% - 30px);
  margin: 0 auto;
  display: flex;
}

.weatherInfoRainForecastTableWeatherScheduleTwoBox > div:first-child {
  margin-right: 10px;
}

.weatherInfoRainForecastTableWeatherScheduleTwoBox > div:last-child {
  margin-left: 10px;
}
</style>
