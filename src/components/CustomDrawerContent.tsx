import React from 'react';
import {
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from 'react-native';
import {
  DrawerContentScrollView,
  DrawerContentComponentProps,
} from '@react-navigation/drawer';
import {COLORS, SPACING} from '../constants';
import * as authService from '../services/authService';

interface DrawerItem {
  label: string;
  emoji: string;
  screen: string;
}

const DRAWER_ITEMS: DrawerItem[] = [
  {label: 'Home', emoji: '🏠', screen: 'Home'},
  {label: 'Personalised Weather', emoji: '🌤️', screen: 'Weather'},
  {label: 'Journal', emoji: '📓', screen: 'Journal'},
  {label: 'Resources', emoji: '🔗', screen: 'Resources'},
];

const CustomDrawerContent: React.FC<DrawerContentComponentProps> = ({
  navigation,
  state,
}) => {
  const activeRouteName = state.routes[state.index]?.name ?? '';

  const handleLogout = async () => {
    await authService.logout();
    navigation.reset({
      index: 0,
      routes: [{name: 'AuthStack' as never}],
    });
  };

  return (
    <DrawerContentScrollView
      contentContainerStyle={styles.container}
      scrollEnabled={false}>
      {/* Drawer header */}
      <View style={styles.header}>
        <Text style={styles.headerEmoji}>🐝</Text>
        <Text style={styles.headerTitle}>CrownBees</Text>
        <Text style={styles.headerSub}>Mason Bee Companion</Text>
      </View>

      <View style={styles.divider} />

      {/* Navigation items */}
      <View style={styles.itemsContainer}>
        {DRAWER_ITEMS.map(item => {
          const isActive = activeRouteName === item.screen;
          return (
            <TouchableOpacity
              key={item.screen}
              style={[styles.drawerItem, isActive && styles.drawerItemActive]}
              onPress={() => navigation.navigate(item.screen as never)}
              activeOpacity={0.7}>
              <Text style={styles.drawerItemEmoji}>{item.emoji}</Text>
              <Text
                style={[
                  styles.drawerItemLabel,
                  isActive && styles.drawerItemLabelActive,
                ]}>
                {item.label}
              </Text>
            </TouchableOpacity>
          );
        })}
      </View>

      {/* Log Out at bottom */}
      <View style={styles.footer}>
        <View style={styles.divider} />
        <TouchableOpacity
          style={styles.logoutButton}
          onPress={handleLogout}
          activeOpacity={0.7}>
          <Text style={styles.logoutEmoji}>🚪</Text>
          <Text style={styles.logoutLabel}>Log Out</Text>
        </TouchableOpacity>
      </View>
    </DrawerContentScrollView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: COLORS.white,
  },
  header: {
    backgroundColor: COLORS.primary,
    paddingVertical: SPACING.xl,
    paddingHorizontal: SPACING.lg,
    alignItems: 'center',
  },
  headerEmoji: {
    fontSize: 44,
    marginBottom: SPACING.xs,
  },
  headerTitle: {
    fontSize: 22,
    fontWeight: 'bold',
    color: COLORS.white,
    letterSpacing: 1,
  },
  headerSub: {
    fontSize: 13,
    color: COLORS.white,
    opacity: 0.85,
    marginTop: 2,
  },
  divider: {
    height: 1,
    backgroundColor: COLORS.lightGray,
    marginVertical: SPACING.xs,
  },
  itemsContainer: {
    flex: 1,
    paddingTop: SPACING.sm,
    paddingHorizontal: SPACING.sm,
  },
  drawerItem: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: SPACING.sm + 2,
    paddingHorizontal: SPACING.md,
    borderRadius: 10,
    marginBottom: 2,
  },
  drawerItemActive: {
    backgroundColor: '#FFF0D0',
  },
  drawerItemEmoji: {
    fontSize: 20,
    marginRight: SPACING.md,
  },
  drawerItemLabel: {
    fontSize: 15,
    color: COLORS.text,
    fontWeight: '500',
  },
  drawerItemLabelActive: {
    color: COLORS.primary,
    fontWeight: '700',
  },
  footer: {
    paddingHorizontal: SPACING.sm,
    paddingBottom: SPACING.lg,
  },
  logoutButton: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: SPACING.sm + 2,
    paddingHorizontal: SPACING.md,
    borderRadius: 10,
    marginTop: SPACING.xs,
  },
  logoutEmoji: {
    fontSize: 20,
    marginRight: SPACING.md,
  },
  logoutLabel: {
    fontSize: 15,
    color: COLORS.error,
    fontWeight: '600',
  },
});

export default CustomDrawerContent;
