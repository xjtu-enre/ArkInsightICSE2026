import argparse
import csv
import numpy as np

# Fixtures
name_for = {'python': 'Python'}

tools = {
    'enre': ['ENRE'],
    'ark': ['Ark'],
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
                header = next(data)  # 读取表头

                # 初始化数据结构
                curr['loc'] = []
                for tool in tools:
                    for metric in metrics:
                        curr[f'{tool}-{metric}'] = []

                for row in data:
                    # 读取LOC
                    loc_num = int(row[1])
                    if logloc:
                        if loc_num == 0:
                            curr['loc'].append(0)
                        else:
                            curr['loc'].append(np.log10(loc_num))
                    else:
                        curr['loc'].append(loc_num)

                    # 读取各个数据列，列顺序（假设固定）：
                    # 2: ENRE-time
                    # 3: ENRE-memory-Heap
                    # 4: ENRE-memory-RSS
                    # 5: Ark-time
                    # 6: Ark-memory-Heap
                    # 7: Ark-memory-RSS
                    try:
                        enre_time = float(row[2]) if row[2] != '' else np.nan
                        enre_mem_heap = float(row[3]) if row[3] != '' else np.nan
                        enre_mem_rss = float(row[4]) if row[4] != '' else np.nan
                        ark_time = float(row[5]) if row[5] != '' else np.nan
                        ark_mem_heap = float(row[6]) if row[6] != '' else np.nan
                        ark_mem_rss = float(row[7]) if row[7] != '' else np.nan
                    except (ValueError, IndexError):
                        enre_time = enre_mem_heap = enre_mem_rss = np.nan
                        ark_time = ark_mem_heap = ark_mem_rss = np.nan

                    curr['enre-time'].append(enre_time * 1000)  # 转成毫秒
                    curr['enre-memory-heap'].append(enre_mem_heap if enre_mem_heap > 0 else np.nan)
                    curr['enre-memory-rss'].append(enre_mem_rss if enre_mem_rss > 0 else np.nan)

                    curr['ark-time'].append(ark_time * 1000)
                    curr['ark-memory-heap'].append(ark_mem_heap if ark_mem_heap > 0 else np.nan)
                    curr['ark-memory-rss'].append(ark_mem_rss if ark_mem_rss > 0 else np.nan)

        except EnvironmentError:
            print(f'No {lang}.csv file found, skipping to the next')
            continue

        # Convert to numpy array and clean invalid (<=0变nan)
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
