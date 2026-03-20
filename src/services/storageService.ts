import AsyncStorage from '@react-native-async-storage/async-storage';
import {STORAGE_KEYS} from '../constants';
import {BeeReleaseEntry, HarvestEntry, PestEntry, User} from '../types';

export const saveUser = async (user: User): Promise<void> => {
  await AsyncStorage.setItem(STORAGE_KEYS.USER, JSON.stringify(user));
};

export const getUser = async (): Promise<User | null> => {
  const data = await AsyncStorage.getItem(STORAGE_KEYS.USER);
  return data ? (JSON.parse(data) as User) : null;
};

export const setLoggedIn = async (value: boolean): Promise<void> => {
  await AsyncStorage.setItem(STORAGE_KEYS.IS_LOGGED_IN, JSON.stringify(value));
};

export const isLoggedIn = async (): Promise<boolean> => {
  const data = await AsyncStorage.getItem(STORAGE_KEYS.IS_LOGGED_IN);
  return data ? (JSON.parse(data) as boolean) : false;
};

export const logout = async (): Promise<void> => {
  await AsyncStorage.multiRemove([
    STORAGE_KEYS.IS_LOGGED_IN,
  ]);
};

export const getBeeReleases = async (): Promise<BeeReleaseEntry[]> => {
  const data = await AsyncStorage.getItem(STORAGE_KEYS.BEE_RELEASES);
  return data ? (JSON.parse(data) as BeeReleaseEntry[]) : [];
};

export const saveBeeRelease = async (entry: BeeReleaseEntry): Promise<void> => {
  const existing = await getBeeReleases();
  existing.push(entry);
  await AsyncStorage.setItem(STORAGE_KEYS.BEE_RELEASES, JSON.stringify(existing));
};

export const getHarvests = async (): Promise<HarvestEntry[]> => {
  const data = await AsyncStorage.getItem(STORAGE_KEYS.HARVESTS);
  return data ? (JSON.parse(data) as HarvestEntry[]) : [];
};

export const saveHarvest = async (entry: HarvestEntry): Promise<void> => {
  const existing = await getHarvests();
  existing.push(entry);
  await AsyncStorage.setItem(STORAGE_KEYS.HARVESTS, JSON.stringify(existing));
};

export const getPests = async (): Promise<PestEntry[]> => {
  const data = await AsyncStorage.getItem(STORAGE_KEYS.PESTS);
  return data ? (JSON.parse(data) as PestEntry[]) : [];
};

export const savePest = async (entry: PestEntry): Promise<void> => {
  const existing = await getPests();
  existing.push(entry);
  await AsyncStorage.setItem(STORAGE_KEYS.PESTS, JSON.stringify(existing));
};
