import React, {useCallback, useEffect, useState} from 'react';
import {
  ActivityIndicator,
  FlatList,
  ScrollView,
  StyleSheet,
  Text,
  View,
} from 'react-native';
import {COLORS, SPACING} from '../constants';
import {getUser} from '../services/storageService';
import {getWeatherByZip} from '../services/weatherService';
import {ForecastDay, WeatherData} from '../types';

const WeatherScreen: React.FC = () => {
  const [weather, setWeather] = useState<WeatherData | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const fetchWeather = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      const user = await getUser();
      if (!user?.zipCode) {
        setError('No zip code found. Please update your profile.');
        return;
      }
      const data = await getWeatherByZip(user.zipCode);
      setWeather(data);
    } catch (err) {
      const message = err instanceof Error ? err.message : 'Failed to load weather data.';
      setError(message);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    fetchWeather();
  }, [fetchWeather]);

  if (loading) {
    return (
      <View style={styles.centered}>
        <ActivityIndicator size="large" color={COLORS.primary} />
        <Text style={styles.loadingText}>Fetching weather…</Text>
      </View>
    );
  }

  if (error) {
    return (
      <ScrollView style={styles.container} contentContainerStyle={styles.centered}>
        <Text style={styles.errorEmoji}>⚠️</Text>
        <Text style={styles.errorTitle}>Weather Unavailable</Text>
        <Text style={styles.errorText}>{error}</Text>
        {error.includes('API key') && (
          <View style={styles.apiHintCard}>
            <Text style={styles.apiHintTitle}>How to fix:</Text>
            <Text style={styles.apiHintText}>
              1. Get a free API key at openweathermap.org/api{'\n'}
              2. Open src/constants/index.ts{'\n'}
              3. Replace YOUR_OPENWEATHERMAP_API_KEY_HERE with your key
            </Text>
          </View>
        )}
      </ScrollView>
    );
  }

  if (!weather) {
    return null;
  }

  return (
    <ScrollView style={styles.container} contentContainerStyle={styles.content}>
      <View style={styles.banner}>
        <Text style={styles.bannerText}>
          📍 Weather data is based on your registered zip code.
        </Text>
      </View>

      {/* Current weather card */}
      <View style={styles.currentCard}>
        <Text style={styles.weatherIcon}>{weather.icon}</Text>
        <Text style={styles.temperature}>{weather.temperature}°F</Text>
        <Text style={styles.condition}>{capitalize(weather.condition)}</Text>
        <View style={styles.detailsRow}>
          <DetailChip icon="💧" label={`${weather.humidity}% Humidity`} />
          <DetailChip icon="💨" label={`${weather.windSpeed} mph Wind`} />
        </View>
      </View>

      {/* 5-day forecast */}
      <Text style={styles.forecastTitle}>5-Day Forecast</Text>
      <FlatList
        data={weather.forecast}
        keyExtractor={(item: ForecastDay) => item.date}
        horizontal
        showsHorizontalScrollIndicator={false}
        contentContainerStyle={styles.forecastList}
        renderItem={({item}: {item: ForecastDay}) => (
          <View style={styles.forecastCard}>
            <Text style={styles.forecastDate}>{item.date}</Text>
            <Text style={styles.forecastIcon}>{item.icon}</Text>
            <Text style={styles.forecastCondition}>{capitalize(item.condition)}</Text>
            <Text style={styles.forecastTemps}>
              {item.maxTemp}° / {item.minTemp}°
            </Text>
          </View>
        )}
      />
    </ScrollView>
  );
};

interface DetailChipProps {
  icon: string;
  label: string;
}

const DetailChip: React.FC<DetailChipProps> = ({icon, label}) => (
  <View style={styles.detailChip}>
    <Text style={styles.detailChipIcon}>{icon}</Text>
    <Text style={styles.detailChipLabel}>{label}</Text>
  </View>
);

const capitalize = (str: string): string =>
  str.replace(/\b\w/g, c => c.toUpperCase());

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: COLORS.background,
  },
  content: {
    paddingBottom: SPACING.xl,
  },
  centered: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    padding: SPACING.lg,
    backgroundColor: COLORS.background,
  },
  loadingText: {
    marginTop: SPACING.sm,
    color: COLORS.mediumGray,
    fontSize: 15,
  },
  errorEmoji: {
    fontSize: 48,
    marginBottom: SPACING.sm,
  },
  errorTitle: {
    fontSize: 20,
    fontWeight: 'bold',
    color: COLORS.error,
    marginBottom: SPACING.sm,
  },
  errorText: {
    fontSize: 14,
    color: COLORS.text,
    textAlign: 'center',
    lineHeight: 22,
  },
  apiHintCard: {
    backgroundColor: COLORS.white,
    borderRadius: 12,
    padding: SPACING.md,
    marginTop: SPACING.md,
    borderLeftWidth: 4,
    borderLeftColor: COLORS.primary,
    width: '100%',
  },
  apiHintTitle: {
    fontWeight: 'bold',
    color: COLORS.text,
    marginBottom: SPACING.xs,
  },
  apiHintText: {
    fontSize: 13,
    color: COLORS.text,
    lineHeight: 22,
  },
  banner: {
    backgroundColor: COLORS.secondary,
    paddingVertical: SPACING.sm,
    paddingHorizontal: SPACING.md,
  },
  bannerText: {
    color: COLORS.white,
    fontSize: 13,
    textAlign: 'center',
  },
  currentCard: {
    backgroundColor: COLORS.primary,
    margin: SPACING.lg,
    borderRadius: 20,
    padding: SPACING.xl,
    alignItems: 'center',
    shadowColor: '#000',
    shadowOffset: {width: 0, height: 4},
    shadowOpacity: 0.15,
    shadowRadius: 10,
    elevation: 6,
  },
  weatherIcon: {
    fontSize: 64,
    marginBottom: SPACING.sm,
  },
  temperature: {
    fontSize: 52,
    fontWeight: 'bold',
    color: COLORS.white,
  },
  condition: {
    fontSize: 18,
    color: COLORS.white,
    marginTop: SPACING.xs,
    opacity: 0.9,
  },
  detailsRow: {
    flexDirection: 'row',
    marginTop: SPACING.md,
    gap: SPACING.md,
  },
  detailChip: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: 'rgba(255,255,255,0.25)',
    borderRadius: 20,
    paddingHorizontal: SPACING.sm,
    paddingVertical: SPACING.xs,
  },
  detailChipIcon: {
    fontSize: 14,
    marginRight: 4,
  },
  detailChipLabel: {
    fontSize: 13,
    color: COLORS.white,
    fontWeight: '500',
  },
  forecastTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    color: COLORS.text,
    marginLeft: SPACING.lg,
    marginBottom: SPACING.sm,
  },
  forecastList: {
    paddingHorizontal: SPACING.lg,
    gap: SPACING.sm,
  },
  forecastCard: {
    backgroundColor: COLORS.white,
    borderRadius: 14,
    padding: SPACING.md,
    alignItems: 'center',
    minWidth: 110,
    shadowColor: '#000',
    shadowOffset: {width: 0, height: 1},
    shadowOpacity: 0.06,
    shadowRadius: 4,
    elevation: 2,
  },
  forecastDate: {
    fontSize: 12,
    fontWeight: '600',
    color: COLORS.mediumGray,
    marginBottom: SPACING.xs,
  },
  forecastIcon: {
    fontSize: 28,
    marginVertical: SPACING.xs,
  },
  forecastCondition: {
    fontSize: 11,
    color: COLORS.text,
    textAlign: 'center',
    marginBottom: SPACING.xs,
  },
  forecastTemps: {
    fontSize: 13,
    fontWeight: 'bold',
    color: COLORS.text,
  },
});

export default WeatherScreen;
