<template>
  <div class="weatherBox">
    <!-- 天气APP中上方的信息 -->
    <div class="weatherMainInfo">
      <div class="weatherMainInfoCity">
        <div class="weatherMainInfoCityName">
          <span class="weatherMainInfoCityNameSpanText">
            {{ AMapLocationDataByLongitudeAndLatitude.township }}
          </span>
        </div>
        <div class="weatherMainInfoCityTemperature">
          <span class="weatherMainInfoCityTemperatureText">
            {{ xiaoMiWeatherData.temperature }}
          </span>
        </div>
        <div class="weatherMainInfoCityWeather">
          <div class="weatherMainInfoCityWeatherText">
            {{ xiaoMiWeatherData.weather }}
          </div>
        </div>
        <div class="weatherMainInfoCityMinMaxTemperature">
          <span class="weatherMainInfoCityMinMaxTemperatureText">MAX：{{ xiaoMiWeatherData.tempMax }}</ span>
          <span class="weatherMainInfoCityMinMaxTemperatureText">MIN：{{ xiaoMiWeatherData.tempMin }}</span>
        </div>
      </div>
    </div>

    <!-- 天气APP下方详情数据 -->
    <div class="weatherInfoRainForecastTable">
      <div class="weatherInfoRainForecastTableBox">
        <span class="weatherInfoRainForecastTableBoxText">
          未来降雨预测
        </span>
        <div class="weatherInfoRainForecastTableBoxTable">
          未来降雨预测图表
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

// 小米天气数据（临时）
const xiaoMiWeatherData = ref({
  temperature: '', // 温度
  weather: '', // 天气
  tempMax: '', // 最大天气
  tempMin: '', // 最小天气
})



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
  const temperatureSymbol = xiaoMiWeatherDataInfo.current.temperature.unit
  xiaoMiWeatherData.value = {
    temperature: xiaoMiWeatherDataInfo.current.temperature.value + temperatureSymbol || '未获取到温度',
    weather: xiaoMiWeatherDataInfo.current.weather.value || '未获取到天气',
    tempMax: xiaoMiWeatherDataInfo.yesterday.tempMax + temperatureSymbol || '未获取到最高温度',
    tempMin: xiaoMiWeatherDataInfo.yesterday.tempMin + temperatureSymbol || '未获取到最低温度',
  };
  console.log('获取天气信息[小米API]如下信息:');
  console.log(JSON.stringify(xiaoMiWeatherData.value))
}

onMounted(async () => {
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

</style>
