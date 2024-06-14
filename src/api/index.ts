import axios from "axios";
import {WeatherDataResponse} from "../entities/WeatherData.ts";
import {LocationResponse, Vec2} from "../entities/Location.ts";

export const getWeather = (code: number) => {
    return axios.get<WeatherDataResponse>("/api/api/weather/city/" + code);
}
export type CityData = {name: string, code: number};
export const getCities = () => {
    return axios.get<CityData[]>("/citycode-o.json");
}
export const getAddress = () => {
    return axios.get<LocationResponse>("https://restapi.amap.com/v3/ip", {params: {key: import.meta.env.VITE_AMAP_API_KEY}});
}
export const reGeo = (location: Vec2) => {
    return axios.get("https://restapi.amap.com/v3/geocode/regeo", {params: {key: import.meta.env.VITE_AMAP_API_KEY, location: `${location.x},${location.y}`, extensions: "all"}});
}