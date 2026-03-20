import React from 'react';
import {
  Linking,
  ScrollView,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from 'react-native';
import {COLORS, SPACING} from '../constants';

interface QuickLink {
  emoji: string;
  title: string;
  description: string;
  url: string;
}

const QUICK_LINKS: QuickLink[] = [
  {
    emoji: '📖',
    title: 'Getting Started',
    description: 'New to mason bees? Start here.',
    url: 'https://www.crownbees.com/pages/getting-started',
  },
  {
    emoji: '🛒',
    title: 'Products',
    description: 'Bee houses, cocoons & supplies.',
    url: 'https://www.crownbees.com/collections/all',
  },
  {
    emoji: '❓',
    title: 'FAQ',
    description: 'Answers to common questions.',
    url: 'https://www.crownbees.com/pages/faq',
  },
  {
    emoji: '📰',
    title: 'Blog',
    description: 'Tips, news & bee stories.',
    url: 'https://www.crownbees.com/blogs/news',
  },
];

const ResourcesScreen: React.FC = () => {
  const openUrl = (url: string) => {
    Linking.openURL(url).catch(() => {
      // Silently fail — URL will not open on simulators without a browser
    });
  };

  return (
    <ScrollView style={styles.container} contentContainerStyle={styles.content}>
      <Text style={styles.heading}>🌿 CrownBees Resources</Text>
      <Text style={styles.description}>
        Access all CrownBees resources, guides, and products.
      </Text>

      {/* Main CTA */}
      <TouchableOpacity
        style={styles.mainButton}
        onPress={() => openUrl('https://www.crownbees.com')}
        activeOpacity={0.85}>
        <Text style={styles.mainButtonEmoji}>🌐</Text>
        <View style={styles.mainButtonTextBlock}>
          <Text style={styles.mainButtonTitle}>Visit CrownBees.com</Text>
          <Text style={styles.mainButtonSub}>
            Explore the full website in your browser
          </Text>
        </View>
        <Text style={styles.mainButtonArrow}>›</Text>
      </TouchableOpacity>

      <Text style={styles.sectionTitle}>Quick Links</Text>

      {QUICK_LINKS.map(link => (
        <TouchableOpacity
          key={link.title}
          style={styles.linkCard}
          onPress={() => openUrl(link.url)}
          activeOpacity={0.8}>
          <Text style={styles.linkEmoji}>{link.emoji}</Text>
          <View style={styles.linkTextBlock}>
            <Text style={styles.linkTitle}>{link.title}</Text>
            <Text style={styles.linkDesc}>{link.description}</Text>
          </View>
          <Text style={styles.linkArrow}>›</Text>
        </TouchableOpacity>
      ))}

      <View style={styles.footerNote}>
        <Text style={styles.footerText}>
          Links open in your device's default browser.
        </Text>
      </View>
    </ScrollView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: COLORS.background,
  },
  content: {
    padding: SPACING.lg,
    paddingBottom: SPACING.xl,
  },
  heading: {
    fontSize: 24,
    fontWeight: 'bold',
    color: COLORS.accent,
    marginBottom: SPACING.xs,
  },
  description: {
    fontSize: 15,
    color: COLORS.mediumGray,
    marginBottom: SPACING.lg,
    lineHeight: 22,
  },
  mainButton: {
    backgroundColor: COLORS.primary,
    borderRadius: 16,
    padding: SPACING.lg,
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: SPACING.lg,
    shadowColor: '#000',
    shadowOffset: {width: 0, height: 3},
    shadowOpacity: 0.12,
    shadowRadius: 8,
    elevation: 5,
  },
  mainButtonEmoji: {
    fontSize: 32,
    marginRight: SPACING.md,
  },
  mainButtonTextBlock: {
    flex: 1,
  },
  mainButtonTitle: {
    fontSize: 17,
    fontWeight: 'bold',
    color: COLORS.white,
  },
  mainButtonSub: {
    fontSize: 13,
    color: COLORS.white,
    opacity: 0.85,
    marginTop: 2,
  },
  mainButtonArrow: {
    fontSize: 28,
    color: COLORS.white,
    fontWeight: 'bold',
  },
  sectionTitle: {
    fontSize: 17,
    fontWeight: 'bold',
    color: COLORS.text,
    marginBottom: SPACING.sm,
  },
  linkCard: {
    backgroundColor: COLORS.white,
    borderRadius: 14,
    padding: SPACING.md,
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: SPACING.sm,
    shadowColor: '#000',
    shadowOffset: {width: 0, height: 1},
    shadowOpacity: 0.06,
    shadowRadius: 4,
    elevation: 2,
  },
  linkEmoji: {
    fontSize: 28,
    marginRight: SPACING.md,
  },
  linkTextBlock: {
    flex: 1,
  },
  linkTitle: {
    fontSize: 15,
    fontWeight: '600',
    color: COLORS.text,
  },
  linkDesc: {
    fontSize: 13,
    color: COLORS.mediumGray,
    marginTop: 2,
  },
  linkArrow: {
    fontSize: 22,
    color: COLORS.mediumGray,
    fontWeight: 'bold',
  },
  footerNote: {
    marginTop: SPACING.lg,
    alignItems: 'center',
  },
  footerText: {
    fontSize: 12,
    color: COLORS.mediumGray,
  },
});

export default ResourcesScreen;
