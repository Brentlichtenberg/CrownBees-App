export interface User {
  email: string;
  password: string;
  zipCode: string;
}

export interface BeeReleaseEntry {
  id: string;
  date: string;
  numberOfBees: number;
  notes: string;
}

export interface HarvestEntry {
  id: string;
  date: string;
  numberOfBees: number;
  notes: string;
}

export interface PestEntry {
  id: string;
  date: string;
  pestType: string;
  severity: 'Low' | 'Medium' | 'High';
  notes: string;
}

export interface WeatherData {
  temperature: number;
  condition: string;
  humidity: number;
  windSpeed: number;
  icon: string;
  forecast: ForecastDay[];
}

export interface ForecastDay {
  date: string;
  minTemp: number;
  maxTemp: number;
  condition: string;
  icon: string;
}
