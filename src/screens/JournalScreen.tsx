import React, {useCallback, useEffect, useState} from 'react';
import {
  Alert,
  FlatList,
  ScrollView,
  StyleSheet,
  Text,
  TextInput,
  TouchableOpacity,
  View,
} from 'react-native';
import {COLORS, SPACING} from '../constants';
import {
  getBeeReleases,
  getHarvests,
  getPests,
  saveBeeRelease,
  saveHarvest,
  savePest,
} from '../services/storageService';
import {BeeReleaseEntry, HarvestEntry, PestEntry} from '../types';
import {generateId} from '../utils';

type TabType = 'BeeRelease' | 'Harvest' | 'PestLog';

const PEST_TYPES = ['Mites', 'Wasps', 'Ants', 'Birds', 'Other'];
const SEVERITIES: Array<PestEntry['severity']> = ['Low', 'Medium', 'High'];

const JournalScreen: React.FC = () => {
  const [activeTab, setActiveTab] = useState<TabType>('BeeRelease');

  // Bee Release state
  const [brDate, setBrDate] = useState('');
  const [brCount, setBrCount] = useState('');
  const [brNotes, setBrNotes] = useState('');
  const [beeReleases, setBeeReleases] = useState<BeeReleaseEntry[]>([]);

  // Harvest state
  const [hvDate, setHvDate] = useState('');
  const [hvCount, setHvCount] = useState('');
  const [hvNotes, setHvNotes] = useState('');
  const [harvests, setHarvests] = useState<HarvestEntry[]>([]);

  // Pest Log state
  const [pstDate, setPstDate] = useState('');
  const [pstType, setPstType] = useState(PEST_TYPES[0]);
  const [pstSeverity, setPstSeverity] = useState<PestEntry['severity']>('Low');
  const [pstNotes, setPstNotes] = useState('');
  const [pests, setPests] = useState<PestEntry[]>([]);

  const loadEntries = useCallback(async () => {
    const [brs, hvs, pss] = await Promise.all([
      getBeeReleases(),
      getHarvests(),
      getPests(),
    ]);
    setBeeReleases(brs.reverse());
    setHarvests(hvs.reverse());
    setPests(pss.reverse());
  }, []);

  useEffect(() => {
    loadEntries();
  }, [loadEntries]);

  const handleSaveBeeRelease = async () => {
    if (!brDate || !brCount) {
      Alert.alert('Validation', 'Please fill in date and number of bees.');
      return;
    }
    const entry: BeeReleaseEntry = {
      id: generateId(),
      date: brDate,
      numberOfBees: parseInt(brCount, 10),
      notes: brNotes,
    };
    await saveBeeRelease(entry);
    setBrDate('');
    setBrCount('');
    setBrNotes('');
    await loadEntries();
  };

  const handleSaveHarvest = async () => {
    if (!hvDate || !hvCount) {
      Alert.alert('Validation', 'Please fill in date and number of bees.');
      return;
    }
    const entry: HarvestEntry = {
      id: generateId(),
      date: hvDate,
      numberOfBees: parseInt(hvCount, 10),
      notes: hvNotes,
    };
    await saveHarvest(entry);
    setHvDate('');
    setHvCount('');
    setHvNotes('');
    await loadEntries();
  };

  const handleSavePest = async () => {
    if (!pstDate) {
      Alert.alert('Validation', 'Please fill in the date.');
      return;
    }
    const entry: PestEntry = {
      id: generateId(),
      date: pstDate,
      pestType: pstType,
      severity: pstSeverity,
      notes: pstNotes,
    };
    await savePest(entry);
    setPstDate('');
    setPstNotes('');
    setPstType(PEST_TYPES[0]);
    setPstSeverity('Low');
    await loadEntries();
  };

  return (
    <View style={styles.container}>
      {/* Tab bar */}
      <View style={styles.tabBar}>
        {(['BeeRelease', 'Harvest', 'PestLog'] as TabType[]).map(tab => (
          <TouchableOpacity
            key={tab}
            style={[styles.tab, activeTab === tab && styles.activeTab]}
            onPress={() => setActiveTab(tab)}>
            <Text style={[styles.tabText, activeTab === tab && styles.activeTabText]}>
              {tab === 'BeeRelease' ? '🐝 Release' : tab === 'Harvest' ? '🌾 Harvest' : '🪲 Pests'}
            </Text>
          </TouchableOpacity>
        ))}
      </View>

      <ScrollView style={styles.scroll} keyboardShouldPersistTaps="handled">
        {activeTab === 'BeeRelease' && (
          <>
            <View style={styles.formCard}>
              <Text style={styles.formTitle}>Log a Bee Release</Text>
              <Text style={styles.label}>Date (YYYY-MM-DD)</Text>
              <TextInput
                style={styles.input}
                placeholder="e.g. 2024-03-15"
                placeholderTextColor={COLORS.mediumGray}
                value={brDate}
                onChangeText={setBrDate}
              />
              <Text style={styles.label}>Number of Bees</Text>
              <TextInput
                style={styles.input}
                placeholder="e.g. 50"
                placeholderTextColor={COLORS.mediumGray}
                value={brCount}
                onChangeText={setBrCount}
                keyboardType="numeric"
              />
              <Text style={styles.label}>Notes</Text>
              <TextInput
                style={[styles.input, styles.multiline]}
                placeholder="Any observations…"
                placeholderTextColor={COLORS.mediumGray}
                value={brNotes}
                onChangeText={setBrNotes}
                multiline
                numberOfLines={3}
              />
              <TouchableOpacity style={styles.saveButton} onPress={handleSaveBeeRelease}>
                <Text style={styles.saveButtonText}>Save Entry</Text>
              </TouchableOpacity>
            </View>

            <Text style={styles.historyTitle}>Past Releases</Text>
            {beeReleases.length === 0 ? (
              <Text style={styles.emptyText}>No entries yet.</Text>
            ) : (
              <FlatList
                data={beeReleases}
                keyExtractor={item => item.id}
                scrollEnabled={false}
                renderItem={({item}) => (
                  <View style={styles.entryCard}>
                    <Text style={styles.entryDate}>📅 {item.date}</Text>
                    <Text style={styles.entryDetail}>🐝 {item.numberOfBees} bees</Text>
                    {item.notes ? (
                      <Text style={styles.entryNotes}>{item.notes}</Text>
                    ) : null}
                  </View>
                )}
              />
            )}
          </>
        )}

        {activeTab === 'Harvest' && (
          <>
            <View style={styles.formCard}>
              <Text style={styles.formTitle}>Log a Harvest</Text>
              <Text style={styles.label}>Date (YYYY-MM-DD)</Text>
              <TextInput
                style={styles.input}
                placeholder="e.g. 2024-08-10"
                placeholderTextColor={COLORS.mediumGray}
                value={hvDate}
                onChangeText={setHvDate}
              />
              <Text style={styles.label}>Number of Bees</Text>
              <TextInput
                style={styles.input}
                placeholder="e.g. 120"
                placeholderTextColor={COLORS.mediumGray}
                value={hvCount}
                onChangeText={setHvCount}
                keyboardType="numeric"
              />
              <Text style={styles.label}>Notes</Text>
              <TextInput
                style={[styles.input, styles.multiline]}
                placeholder="Any observations…"
                placeholderTextColor={COLORS.mediumGray}
                value={hvNotes}
                onChangeText={setHvNotes}
                multiline
                numberOfLines={3}
              />
              <TouchableOpacity style={styles.saveButton} onPress={handleSaveHarvest}>
                <Text style={styles.saveButtonText}>Save Entry</Text>
              </TouchableOpacity>
            </View>

            <Text style={styles.historyTitle}>Past Harvests</Text>
            {harvests.length === 0 ? (
              <Text style={styles.emptyText}>No entries yet.</Text>
            ) : (
              <FlatList
                data={harvests}
                keyExtractor={item => item.id}
                scrollEnabled={false}
                renderItem={({item}) => (
                  <View style={styles.entryCard}>
                    <Text style={styles.entryDate}>📅 {item.date}</Text>
                    <Text style={styles.entryDetail}>🌾 {item.numberOfBees} bees</Text>
                    {item.notes ? (
                      <Text style={styles.entryNotes}>{item.notes}</Text>
                    ) : null}
                  </View>
                )}
              />
            )}
          </>
        )}

        {activeTab === 'PestLog' && (
          <>
            <View style={styles.formCard}>
              <Text style={styles.formTitle}>Log a Pest Observation</Text>
              <Text style={styles.label}>Date (YYYY-MM-DD)</Text>
              <TextInput
                style={styles.input}
                placeholder="e.g. 2024-05-01"
                placeholderTextColor={COLORS.mediumGray}
                value={pstDate}
                onChangeText={setPstDate}
              />

              <Text style={styles.label}>Pest Type</Text>
              <View style={styles.pillRow}>
                {PEST_TYPES.map(pt => (
                  <TouchableOpacity
                    key={pt}
                    style={[styles.pill, pstType === pt && styles.pillActive]}
                    onPress={() => setPstType(pt)}>
                    <Text
                      style={[styles.pillText, pstType === pt && styles.pillTextActive]}>
                      {pt}
                    </Text>
                  </TouchableOpacity>
                ))}
              </View>

              <Text style={styles.label}>Severity</Text>
              <View style={styles.pillRow}>
                {SEVERITIES.map(sv => (
                  <TouchableOpacity
                    key={sv}
                    style={[
                      styles.pill,
                      pstSeverity === sv && styles.pillActive,
                      sv === 'High' && pstSeverity === sv && styles.pillDanger,
                    ]}
                    onPress={() => setPstSeverity(sv)}>
                    <Text
                      style={[styles.pillText, pstSeverity === sv && styles.pillTextActive]}>
                      {sv}
                    </Text>
                  </TouchableOpacity>
                ))}
              </View>

              <Text style={styles.label}>Notes</Text>
              <TextInput
                style={[styles.input, styles.multiline]}
                placeholder="Describe what you observed…"
                placeholderTextColor={COLORS.mediumGray}
                value={pstNotes}
                onChangeText={setPstNotes}
                multiline
                numberOfLines={3}
              />
              <TouchableOpacity style={styles.saveButton} onPress={handleSavePest}>
                <Text style={styles.saveButtonText}>Save Entry</Text>
              </TouchableOpacity>
            </View>

            <Text style={styles.historyTitle}>Past Pest Logs</Text>
            {pests.length === 0 ? (
              <Text style={styles.emptyText}>No entries yet.</Text>
            ) : (
              <FlatList
                data={pests}
                keyExtractor={item => item.id}
                scrollEnabled={false}
                renderItem={({item}) => (
                  <View style={styles.entryCard}>
                    <Text style={styles.entryDate}>📅 {item.date}</Text>
                    <Text style={styles.entryDetail}>
                      🪲 {item.pestType} —{' '}
                      <Text
                        style={
                          item.severity === 'High'
                            ? styles.severityHigh
                            : item.severity === 'Medium'
                            ? styles.severityMedium
                            : styles.severityLow
                        }>
                        {item.severity}
                      </Text>
                    </Text>
                    {item.notes ? (
                      <Text style={styles.entryNotes}>{item.notes}</Text>
                    ) : null}
                  </View>
                )}
              />
            )}
          </>
        )}
      </ScrollView>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: COLORS.background,
  },
  tabBar: {
    flexDirection: 'row',
    backgroundColor: COLORS.white,
    borderBottomWidth: 1,
    borderBottomColor: COLORS.lightGray,
  },
  tab: {
    flex: 1,
    paddingVertical: SPACING.sm + 2,
    alignItems: 'center',
  },
  activeTab: {
    borderBottomWidth: 3,
    borderBottomColor: COLORS.primary,
  },
  tabText: {
    fontSize: 13,
    fontWeight: '500',
    color: COLORS.mediumGray,
  },
  activeTabText: {
    color: COLORS.primary,
    fontWeight: '700',
  },
  scroll: {
    flex: 1,
  },
  formCard: {
    backgroundColor: COLORS.white,
    margin: SPACING.md,
    borderRadius: 16,
    padding: SPACING.md,
    shadowColor: '#000',
    shadowOffset: {width: 0, height: 2},
    shadowOpacity: 0.07,
    shadowRadius: 6,
    elevation: 3,
  },
  formTitle: {
    fontSize: 16,
    fontWeight: 'bold',
    color: COLORS.accent,
    marginBottom: SPACING.sm,
  },
  label: {
    fontSize: 13,
    fontWeight: '600',
    color: COLORS.text,
    marginTop: SPACING.sm,
    marginBottom: SPACING.xs,
  },
  input: {
    borderWidth: 1,
    borderColor: COLORS.lightGray,
    borderRadius: 8,
    paddingHorizontal: SPACING.sm,
    paddingVertical: SPACING.xs + 4,
    fontSize: 14,
    color: COLORS.text,
    backgroundColor: COLORS.background,
  },
  multiline: {
    height: 80,
    textAlignVertical: 'top',
  },
  saveButton: {
    backgroundColor: COLORS.secondary,
    borderRadius: 10,
    paddingVertical: SPACING.sm + 2,
    alignItems: 'center',
    marginTop: SPACING.md,
  },
  saveButtonText: {
    color: COLORS.white,
    fontWeight: 'bold',
    fontSize: 15,
  },
  historyTitle: {
    fontSize: 16,
    fontWeight: 'bold',
    color: COLORS.text,
    marginLeft: SPACING.md,
    marginTop: SPACING.sm,
    marginBottom: SPACING.xs,
  },
  emptyText: {
    color: COLORS.mediumGray,
    fontSize: 14,
    textAlign: 'center',
    marginTop: SPACING.md,
    marginBottom: SPACING.xl,
  },
  entryCard: {
    backgroundColor: COLORS.white,
    marginHorizontal: SPACING.md,
    marginBottom: SPACING.sm,
    borderRadius: 12,
    padding: SPACING.md,
    borderLeftWidth: 4,
    borderLeftColor: COLORS.primary,
    shadowColor: '#000',
    shadowOffset: {width: 0, height: 1},
    shadowOpacity: 0.05,
    shadowRadius: 3,
    elevation: 1,
  },
  entryDate: {
    fontSize: 13,
    color: COLORS.mediumGray,
    marginBottom: 2,
  },
  entryDetail: {
    fontSize: 14,
    fontWeight: '600',
    color: COLORS.text,
  },
  entryNotes: {
    fontSize: 13,
    color: COLORS.text,
    marginTop: 4,
    opacity: 0.8,
  },
  pillRow: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: SPACING.xs,
    marginBottom: SPACING.xs,
  },
  pill: {
    borderWidth: 1,
    borderColor: COLORS.lightGray,
    borderRadius: 20,
    paddingHorizontal: SPACING.sm,
    paddingVertical: SPACING.xs,
    backgroundColor: COLORS.background,
  },
  pillActive: {
    backgroundColor: COLORS.primary,
    borderColor: COLORS.primary,
  },
  pillDanger: {
    backgroundColor: COLORS.error,
    borderColor: COLORS.error,
  },
  pillText: {
    fontSize: 13,
    color: COLORS.text,
  },
  pillTextActive: {
    color: COLORS.white,
    fontWeight: '600',
  },
  severityHigh: {
    color: COLORS.error,
    fontWeight: 'bold',
  },
  severityMedium: {
    color: COLORS.primary,
    fontWeight: 'bold',
  },
  severityLow: {
    color: COLORS.secondary,
    fontWeight: 'bold',
  },
});

export default JournalScreen;
