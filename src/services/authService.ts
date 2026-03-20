import {User} from '../types';
import {validateEmail, validateZipCode} from '../utils';
import * as storageService from './storageService';

export const register = async (
  email: string,
  password: string,
  zipCode: string,
): Promise<{success: boolean; error?: string}> => {
  if (!email || !password || !zipCode) {
    return {success: false, error: 'All fields are required.'};
  }
  if (!validateEmail(email)) {
    return {success: false, error: 'Please enter a valid email address.'};
  }
  if (password.length < 6) {
    return {success: false, error: 'Password must be at least 6 characters.'};
  }
  if (!validateZipCode(zipCode)) {
    return {success: false, error: 'Please enter a valid US zip code.'};
  }

  // NOTE: Passwords are stored locally in plaintext for this demo app.
  // In a production app with a backend, never store raw passwords — use a
  // server-side auth flow (e.g., JWT) so passwords are never persisted on device.
  const user: User = {email, password, zipCode};
  await storageService.saveUser(user);
  await storageService.setLoggedIn(true);
  return {success: true};
};

export const login = async (
  email: string,
  password: string,
): Promise<{success: boolean; error?: string}> => {
  if (!email || !password) {
    return {success: false, error: 'Email and password are required.'};
  }
  if (!validateEmail(email)) {
    return {success: false, error: 'Please enter a valid email address.'};
  }

  const user = await storageService.getUser();
  if (!user) {
    return {success: false, error: 'No account found. Please register first.'};
  }
  if (user.email !== email || user.password !== password) {
    return {success: false, error: 'Invalid email or password.'};
  }

  await storageService.setLoggedIn(true);
  return {success: true};
};

export const logout = async (): Promise<void> => {
  await storageService.logout();
};

export const getCurrentUser = async (): Promise<User | null> => {
  return storageService.getUser();
};
