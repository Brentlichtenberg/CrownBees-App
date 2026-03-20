import {WEATHER_API_BASE_URL, WEATHER_API_KEY} from '../constants';
import {ForecastDay, WeatherData} from '../types';

const PLACEHOLDER_KEY = 'YOUR_OPENWEATHERMAP_API_KEY_HERE';

export const getWeatherByZip = async (zipCode: string): Promise<WeatherData> => {
  if (WEATHER_API_KEY === PLACEHOLDER_KEY) {
    throw new Error(
      'Weather API key not configured. Please replace YOUR_OPENWEATHERMAP_API_KEY_HERE in src/constants/index.ts with a real OpenWeatherMap API key.',
    );
  }

  const currentUrl = `${WEATHER_API_BASE_URL}/weather?zip=${zipCode},us&appid=${WEATHER_API_KEY}&units=imperial`;
  const forecastUrl = `${WEATHER_API_BASE_URL}/forecast?zip=${zipCode},us&appid=${WEATHER_API_KEY}&units=imperial`;

  const [currentRes, forecastRes] = await Promise.all([
    fetch(currentUrl),
    fetch(forecastUrl),
  ]);

  if (!currentRes.ok || !forecastRes.ok) {
    const errorData = await currentRes.json().catch(() => ({}));
    const message = (errorData as {message?: string}).message ?? 'Failed to fetch weather data.';
    throw new Error(message);
  }

  const currentData = (await currentRes.json()) as {
    main: {temp: number; humidity: number};
    weather: {description: string; icon: string}[];
    wind: {speed: number};
  };

  const forecastData = (await forecastRes.json()) as {
    list: {
      dt: number;
      main: {temp_min: number; temp_max: number};
      weather: {description: string; icon: string}[];
    }[];
  };

  // Group forecast by day and pick one entry per day (noon-ish)
  const dailyMap = new Map<string, (typeof forecastData.list)[0]>();
  for (const item of forecastData.list) {
    const dateKey = new Date(item.dt * 1000).toLocaleDateString('en-US', {
      month: 'short',
      day: 'numeric',
    });
    if (!dailyMap.has(dateKey)) {
      dailyMap.set(dateKey, item);
    }
  }

  const forecast: ForecastDay[] = Array.from(dailyMap.entries())
    .slice(0, 5)
    .map(([date, item]) => ({
      date,
      minTemp: Math.round(item.main.temp_min),
      maxTemp: Math.round(item.main.temp_max),
      condition: item.weather[0]?.description ?? '',
      icon: mapWeatherIcon(item.weather[0]?.icon ?? ''),
    }));

  return {
    temperature: Math.round(currentData.main.temp),
    condition: currentData.weather[0]?.description ?? '',
    humidity: currentData.main.humidity,
    windSpeed: Math.round(currentData.wind.speed),
    icon: mapWeatherIcon(currentData.weather[0]?.icon ?? ''),
    forecast,
  };
};

const mapWeatherIcon = (iconCode: string): string => {
  if (iconCode.startsWith('01')) {
    return '☀️';
  }
  if (iconCode.startsWith('02')) {
    return '🌤️';
  }
  if (iconCode.startsWith('03')) {
    return '⛅';
  }
  if (iconCode.startsWith('04')) {
    return '☁️';
  }
  if (iconCode.startsWith('09') || iconCode.startsWith('10')) {
    return '🌧️';
  }
  if (iconCode.startsWith('11')) {
    return '⛈️';
  }
  if (iconCode.startsWith('13')) {
    return '❄️';
  }
  if (iconCode.startsWith('50')) {
    return '🌫️';
  }
  return '🌡️';
};
