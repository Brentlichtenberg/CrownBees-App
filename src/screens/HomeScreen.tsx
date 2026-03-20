import React from 'react';
import {ScrollView, StyleSheet, Text, View} from 'react-native';
import {COLORS, SPACING} from '../constants';

const HomeScreen: React.FC = () => {
  return (
    <ScrollView style={styles.container} contentContainerStyle={styles.content}>
      {/* Hero image placeholder */}
      <View style={styles.heroPlaceholder}>
        <Text style={styles.heroEmoji}>🐝</Text>
        <Text style={styles.heroPlaceholderText}>Hero Image Coming Soon</Text>
      </View>

      <Text style={styles.welcomeTitle}>Welcome to CrownBees!</Text>
      <Text style={styles.subtitle}>
        Your mason bee companion app — content coming soon.
      </Text>

      <View style={styles.infoCard}>
        <Text style={styles.infoCardTitle}>🌸 About Mason Bees</Text>
        <Text style={styles.infoCardBody}>
          Mason bees are gentle, highly efficient pollinators that are easy to raise at
          home. Unlike honeybees, they are solitary — each female lays eggs in small
          tubes or holes and provisions them with pollen and nectar.
        </Text>
        <Text style={styles.infoCardBody}>
          CrownBees is dedicated to helping people raise native mason and leafcutter
          bees to boost garden pollination and support healthy ecosystems.
        </Text>
      </View>

      <View style={styles.featuresRow}>
        <FeatureTile emoji="🌤️" label="Weather" />
        <FeatureTile emoji="📓" label="Journal" />
        <FeatureTile emoji="🔗" label="Resources" />
      </View>
    </ScrollView>
  );
};

interface FeatureTileProps {
  emoji: string;
  label: string;
}

const FeatureTile: React.FC<FeatureTileProps> = ({emoji, label}) => (
  <View style={styles.featureTile}>
    <Text style={styles.featureEmoji}>{emoji}</Text>
    <Text style={styles.featureLabel}>{label}</Text>
  </View>
);

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: COLORS.background,
  },
  content: {
    paddingBottom: SPACING.xl,
  },
  heroPlaceholder: {
    backgroundColor: COLORS.primary,
    height: 200,
    alignItems: 'center',
    justifyContent: 'center',
  },
  heroEmoji: {
    fontSize: 56,
    marginBottom: SPACING.sm,
  },
  heroPlaceholderText: {
    color: COLORS.white,
    fontSize: 16,
    fontWeight: '600',
    letterSpacing: 0.5,
  },
  welcomeTitle: {
    fontSize: 26,
    fontWeight: 'bold',
    color: COLORS.accent,
    textAlign: 'center',
    marginTop: SPACING.lg,
    marginHorizontal: SPACING.lg,
  },
  subtitle: {
    fontSize: 15,
    color: COLORS.mediumGray,
    textAlign: 'center',
    marginTop: SPACING.sm,
    marginHorizontal: SPACING.lg,
    lineHeight: 22,
  },
  infoCard: {
    backgroundColor: COLORS.white,
    borderRadius: 16,
    margin: SPACING.lg,
    padding: SPACING.lg,
    shadowColor: '#000',
    shadowOffset: {width: 0, height: 2},
    shadowOpacity: 0.07,
    shadowRadius: 6,
    elevation: 3,
    borderLeftWidth: 4,
    borderLeftColor: COLORS.primary,
  },
  infoCardTitle: {
    fontSize: 17,
    fontWeight: 'bold',
    color: COLORS.text,
    marginBottom: SPACING.sm,
  },
  infoCardBody: {
    fontSize: 14,
    color: COLORS.text,
    lineHeight: 22,
    marginBottom: SPACING.sm,
  },
  featuresRow: {
    flexDirection: 'row',
    justifyContent: 'space-around',
    marginHorizontal: SPACING.lg,
    marginTop: SPACING.sm,
  },
  featureTile: {
    backgroundColor: COLORS.white,
    borderRadius: 12,
    paddingVertical: SPACING.md,
    paddingHorizontal: SPACING.lg,
    alignItems: 'center',
    shadowColor: '#000',
    shadowOffset: {width: 0, height: 1},
    shadowOpacity: 0.06,
    shadowRadius: 4,
    elevation: 2,
    minWidth: 90,
  },
  featureEmoji: {
    fontSize: 28,
    marginBottom: SPACING.xs,
  },
  featureLabel: {
    fontSize: 13,
    fontWeight: '600',
    color: COLORS.text,
  },
});

export default HomeScreen;
