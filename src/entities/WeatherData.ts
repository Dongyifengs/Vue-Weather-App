export interface CityInfo {
    city: string;
    citykey: string;
    parent: string;
    updateTime: string;
}
export interface ForeCaseData {
    date: string;
    high: string;
    low: string;
    ymd: string;
    week: string;
    sunrise: string;
    sunset: string;
    aqi: number;
    fx: string;
    fl: string;
    type: string;
    notice: string;
}
export interface WeatherData {
    shidu: string;
    pm25: number;
    pm10: number;
    quality: string;
    wendu: string;
    ganmao: string;
    forecast: ForeCaseData[];
    yesterday: ForeCaseData;
}
export interface WeatherDataResponse {
    message: string;
    status: number;
    date: string;
    time: string;
    cityinfo: CityInfo;
    data: WeatherData;
}
export type aqiLevels = "优" | "良" | "轻度污染" | "中度污染" | "重度污染" | "严重污染";
export interface CurrentWeatherData {
    humidity: number;
    reportTime: string;
    temperature: number;
    weather: string;
    windDirection: string;
    windPower: number;
    high: number;
    low: number;
    aqi: number;
    aqiLevel: aqiLevels
}
export const getAqiLevel = (aqi: number): aqiLevels => {
    if (aqi <= 50){
        return "优";
    }else if(aqi <= 100){
        return "良";
    }else if(aqi <= 150){
        return "轻度污染";
    }else if(aqi <= 200){
        return "中度污染";
    }else if(aqi <= 300){
        return "重度污染";
    }else{
        return "严重污染";
    }
}