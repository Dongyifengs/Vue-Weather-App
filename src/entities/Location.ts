export interface LocationResponse {
    status: string;
    info: string;
    infocode: string;
    province: string;
    city: string;
    adcode: string;
    rectangle: string
}
export interface Vec2 {
    x: number;
    y: number;
}
export const createVec2FromLocation = (location: string): Vec2 => {
    const vec2Location = location.split(",");
    if (vec2Location.length != 2){
        throw Error("输入了错误的location");
    }
    const [x, y] = vec2Location;
    return {x: Number.parseFloat(x), y: Number.parseFloat(y)};
}
export class Vec2LocationArea {
    public start: Vec2;
    public end:Vec2;
    constructor(rectangle: string) {
        const vec2Location = rectangle.split(";");
        if (vec2Location.length != 2){
            throw Error("输入了错误的rectangle");
        }
        const [start, end] = vec2Location;
        this.start = createVec2FromLocation(start);
        this.end = createVec2FromLocation(end);
    }
    getCenter(): Vec2 {
        return {x: (this.start.x + this.end.x) / 2, y: (this.start.y + this.end.y) / 2};
    }
}
export interface Location {
    status: number;
    info: string;
    infocode: number;
    province: string;
    city: string;
    adcode: number;
    rectangle: Vec2LocationArea;
}
export const getLocation = (response: LocationResponse): Location => {
    return {
        status: Number.parseInt(response.status),
        info: response.info,
        infocode: Number.parseInt(response.infocode),
        province: response.province,
        city: response.city,
        adcode: Number.parseInt(response.adcode),
        rectangle: new Vec2LocationArea(response.rectangle)
    }
}