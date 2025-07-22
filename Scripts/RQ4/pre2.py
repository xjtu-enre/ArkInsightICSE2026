import argparse
import csv
import numpy as np

# Fixtures
name_for = {'python': 'Python'}

tools = {
    'ArkInsight': ['ArkInsight'],
    'ArkAnalyzer': ['ArkAnalyzer'],
}

def init(logloc=False):
    parser = argparse.ArgumentParser()
    parser.add_argument('mode', help='Specify the deploy mode')
    parser.add_argument('lang', help='Specify the target language')
    parser.add_argument('-p', '--prune-all',
                        help="Remove a result among all tools' if it's going to be removed in one's",
                        action='store_true')

    args = parser.parse_args()

    mode = args.mode
    if mode not in ['view', 'save']:
        raise ValueError(f'Invalid mode {mode}, only support view / save')

    langs = args.lang
    if langs not in ['python']:
        raise ValueError(f'Invalid lang {langs}, only support python')
    langs = [langs]

    metrics = ['time', 'memory-heap', 'memory-rss']

    collection = {}

    # Loading data
    for lang in langs:
        print(f'Loading {lang} data')
        curr = collection[lang] = {}
        try:
            with open(f'{lang}_heapTotal.csv', 'r', encoding='utf-8-sig') as file:
                data = csv.reader(file)
                header = next(data)  

                curr['loc'] = []
                for tool in tools:
                    for metric in metrics:
                        curr[f'{tool}-{metric}'] = []

                for row in data:
                    # load LOC
                    loc_num = int(row[1])
                    if logloc:
                        if loc_num == 0:
                            curr['loc'].append(0)
                        else:
                            curr['loc'].append(np.log10(loc_num))
                    else:
                        curr['loc'].append(loc_num)

                    # 1: project
                    # 2: ArkInsight-time
                    # 3: ArkInsight-memory-Heap
                    # 4: ArkInsight-memory-RSS
                    # 5: ArkAnalyzer-time
                    # 6: ArkAnalyzer-memory-Heap
                    # 7: ArkAnalyzer-memory-RSS
                    try:
                        ArkInsight_time = float(row[2]) if row[2] != '' else np.nan
                        ArkInsight_mem_heap = float(row[3]) if row[3] != '' else np.nan
                        ArkInsight_mem_rss = float(row[4]) if row[4] != '' else np.nan
                        ArkAnalyzer_time = float(row[5]) if row[5] != '' else np.nan
                        ArkAnalyzer_mem_heap = float(row[6]) if row[6] != '' else np.nan
                        ArkAnalyzer_mem_rss = float(row[7]) if row[7] != '' else np.nan
                    except (ValueError, IndexError):
                        ArkInsight_time = ArkInsight_mem_heap = ArkInsight_mem_rss = np.nan
                        ArkAnalyzer_time = ArkAnalyzer_mem_heap = ArkAnalyzer_mem_rss = np.nan

                    curr['ArkInsight-time'].append(ArkInsight_time * 1000)  # ms
                    curr['ArkInsight-memory-heap'].append(ArkInsight_mem_heap if ArkInsight_mem_heap > 0 else np.nan)
                    curr['ArkInsight-memory-rss'].append(ArkInsight_mem_rss if ArkInsight_mem_rss > 0 else np.nan)

                    curr['ArkAnalyzer_time'].append(ArkAnalyzer_time * 1000)
                    curr['ArkAnalyzer-memory-heap'].append(ArkAnalyzer_mem_heap if ArkAnalyzer_mem_heap > 0 else np.nan)
                    curr['ArkAnalyzer-memory-rss'].append(ArkAnalyzer_mem_rss if ArkAnalyzer_mem_rss > 0 else np.nan)

        except EnvironmentError:
            print(f'No {lang}.csv file found, skipping to the next')
            continue

        # Convert to numpy array and clean invalid (<=0 nan)
        for key in curr:
            if key != 'loc':
                curr[key] = np.array(curr[key])
                curr[key][curr[key] <= 0] = np.nan

        # remove invalid loc
        indices = [i for i, v in enumerate(curr['loc']) if v <= 0]
        for key in curr.keys():
            curr[key] = np.delete(curr[key], indices)

    return collection, {
        'prune_all': args.prune_all
    }, mode, langs, tools, metrics
