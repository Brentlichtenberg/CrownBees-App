import React, {useCallback, useEffect, useState} from 'react';
import {ActivityIndicator, StyleSheet, Text, TouchableOpacity, View} from 'react-native';
import {NavigationContainer} from '@react-navigation/native';
import {createNativeStackNavigator} from '@react-navigation/native-stack';
import {createDrawerNavigator} from '@react-navigation/drawer';
import {COLORS, SPACING} from '../constants';
import * as authService from '../services/authService';
import {isLoggedIn} from '../services/storageService';

// Screens
import LoginScreen from '../screens/LoginScreen';
import RegisterScreen from '../screens/RegisterScreen';
import HomeScreen from '../screens/HomeScreen';
import WeatherScreen from '../screens/WeatherScreen';
import JournalScreen from '../screens/JournalScreen';
import ResourcesScreen from '../screens/ResourcesScreen';
import CustomDrawerContent from '../components/CustomDrawerContent';

// ─── Param list types ────────────────────────────────────────────────────────

export type AuthStackParamList = {
  Login: undefined;
  Register: undefined;
  /** Allows navigating to the main app after auth */
  Home: undefined;
};

export type DrawerParamList = {
  Home: undefined;
  Weather: undefined;
  Journal: undefined;
  Resources: undefined;
};

export type RootStackParamList = {
  AuthStack: undefined;
  MainDrawer: undefined;
};

// ─── Navigators ──────────────────────────────────────────────────────────────

const AuthStack = createNativeStackNavigator<AuthStackParamList>();
const Drawer = createDrawerNavigator<DrawerParamList>();
const RootStack = createNativeStackNavigator<RootStackParamList>();

// ─── Auth navigator ──────────────────────────────────────────────────────────

const AuthNavigator: React.FC = () => (
  <AuthStack.Navigator screenOptions={{headerShown: false}}>
    <AuthStack.Screen name="Login" component={LoginScreen} />
    <AuthStack.Screen name="Register" component={RegisterScreen} />
  </AuthStack.Navigator>
);

// ─── Drawer navigator (main app) ─────────────────────────────────────────────

const HamburgerButton: React.FC<{onPress: () => void}> = ({onPress}) => (
  <TouchableOpacity onPress={onPress} style={styles.hamburger} hitSlop={8}>
    <Text style={styles.hamburgerIcon}>☰</Text>
  </TouchableOpacity>
);

const MainDrawerNavigator: React.FC = () => (
  <Drawer.Navigator
    drawerContent={props => <CustomDrawerContent {...props} />}
    screenOptions={({navigation}) => ({
      headerStyle: {backgroundColor: COLORS.primary},
      headerTintColor: COLORS.white,
      headerTitleStyle: {fontWeight: 'bold'},
      headerRight: () => (
        <HamburgerButton onPress={() => navigation.toggleDrawer()} />
      ),
      headerLeft: () => null,
      drawerType: 'front',
      drawerStyle: {backgroundColor: COLORS.white},
    })}>
    <Drawer.Screen
      name="Home"
      component={HomeScreen}
      options={{title: 'CrownBees 🐝'}}
    />
    <Drawer.Screen
      name="Weather"
      component={WeatherScreen}
      options={{title: 'Personalised Weather'}}
    />
    <Drawer.Screen
      name="Journal"
      component={JournalScreen}
      options={{title: 'Bee Journal'}}
    />
    <Drawer.Screen
      name="Resources"
      component={ResourcesScreen}
      options={{title: 'Resources'}}
    />
  </Drawer.Navigator>
);

// ─── Root navigator ───────────────────────────────────────────────────────────

const AppNavigator: React.FC = () => {
  const [loggedIn, setLoggedIn] = useState<boolean | null>(null);

  const checkAuthState = useCallback(async () => {
    const status = await isLoggedIn();
    setLoggedIn(status);
  }, []);

  useEffect(() => {
    checkAuthState();
  }, [checkAuthState]);

  if (loggedIn === null) {
    return (
      <View style={styles.loadingContainer}>
        <Text style={styles.loadingEmoji}>🐝</Text>
        <ActivityIndicator size="large" color={COLORS.primary} style={{marginTop: SPACING.md}} />
      </View>
    );
  }

  return (
    <NavigationContainer>
      <RootStack.Navigator screenOptions={{headerShown: false}}>
        {loggedIn ? (
          <RootStack.Screen name="MainDrawer" component={MainDrawerNavigator} />
        ) : (
          <RootStack.Screen name="AuthStack" component={AuthNavigator} />
        )}
      </RootStack.Navigator>
    </NavigationContainer>
  );
};

const styles = StyleSheet.create({
  loadingContainer: {
    flex: 1,
    backgroundColor: COLORS.background,
    alignItems: 'center',
    justifyContent: 'center',
  },
  loadingEmoji: {
    fontSize: 56,
  },
  hamburger: {
    marginRight: SPACING.md,
  },
  hamburgerIcon: {
    fontSize: 22,
    color: COLORS.white,
    fontWeight: 'bold',
  },
});

export default AppNavigator;
