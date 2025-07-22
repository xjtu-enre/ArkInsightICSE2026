from colour import Color
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.patches as pch
import math

from pre2 import init

# load data
collection, tags, mode, langs, tools, metrics = init()

# metric
features = [
    {'key': 'time', 'text': 'Completion Time (ms)'},
    {'key': 'memory-heap', 'text': 'Memory Usage Heap (MB)'},
    {'key': 'memory-rss', 'text': 'Memory Usage RSS (MB)'}
]

SLICE_POINT = 5 * 1000  # 5kLoC

tools = {
    'enre': ['ENRE'],
    'ark': ['Arkanalyzer'],
}

# param
HEIGHT = 1
BOX_WIDTH = 0.5
LIGHT_GRAY = '#f0f0f0'
DARKER_GRAY = '#9f9f9f'
GRADIENT_BASE = '#80bfff'
HEAT_RESOLUTION = 300
HEAT_COLOR_DOWN = [-0.45, 0.4]
HEAT_COLOR_KEY = ['hue', 'luminance']
LOC_LABEL_FONT_SIZE = 12


def cmapping(percentage):
    color = Color(GRADIENT_BASE)
    for ih, _ in enumerate(HEAT_COLOR_KEY):
        getattr(color, f'set_{HEAT_COLOR_KEY[ih]}')(
            getattr(color, f'get_{HEAT_COLOR_KEY[ih]}')() - HEAT_COLOR_DOWN[ih] * percentage)
    return color.web


plt.style.use('./my.mplstyle')

lang = langs[0]  # only python
raw_data = collection[lang]

# heat
heat_min = math.floor(raw_data['loc'].min() / 100) * 100
heat_max_val = math.ceil(raw_data['loc'].max() / 1000) * 1000

fig = plt.figure(figsize=(17, 8))
subs = fig.subfigures(len(features), 1)
fig.subplots_adjust(hspace=2)

# fig.set_constrained_layout(True)
# #

# fig.subplots_adjust(
#     top=0.95,     #
#     bottom=0.25,  #
#     hspace=0.9,    #
#     left=0.05, right=0.93
# )

axs = []

for i, _ in enumerate(features):
    # subs[i].subplots(1, 3, width_ratios=[40, 1, 40])
    # subs[i].subplots_adjust(wspace=0.11)
    # subs[i].suptitle(features[i]['text'], weight='bold')
    # axs.append([subs[i].axes[0], subs[i].axes[2], subs[i].axes[1]])

    subs[i].subplots(1, 3, width_ratios=[35, 2, 35])
    subs[i].subplots_adjust(wspace=0.18, bottom=0.15, top=0.85)
    subs[i].suptitle(features[i]['text'], weight='bold')
    axs.append([subs[i].axes[0], subs[i].axes[2], subs[i].axes[1]])

    heat_indicator = subs[i].axes[1]
    heat_indicator.set_xticks([0.5], ['kLoC'], fontdict={'fontsize': LOC_LABEL_FONT_SIZE})

    for j in range(HEAT_RESOLUTION):
        color = Color(GRADIENT_BASE)
        for ih, _ in enumerate(HEAT_COLOR_KEY):
            getattr(color, f'set_{HEAT_COLOR_KEY[ih]}')(
                getattr(color, f'get_{HEAT_COLOR_KEY[ih]}')() - HEAT_COLOR_DOWN[ih] * j / HEAT_RESOLUTION)
        heat_indicator.add_patch(pch.Rectangle(
            (0, j / HEAT_RESOLUTION),
            1, 1 / HEAT_RESOLUTION,
            facecolor=color.web,
        ))
    heat_indicator.set_ylim(0, 1)
    heat_indicator.set_yticks(
        [0, 0.5, 1],
        labels=[
            int(heat_min / 1000),
            int((heat_min + heat_max_val) / 2000),
            int(heat_max_val / 1000)
        ],
        fontdict={'fontsize': LOC_LABEL_FONT_SIZE}
    )

for inf, feature in enumerate(features):
    data = {}
    print(f"\n=== Feature: {feature['text']} ===")

    for tool in tools:

        inkey = f'{tool}-{feature["key"]}'
        for iv, value in enumerate(raw_data[inkey]):

            loc = raw_data['loc'][iv]
            outkey = f'{inkey}-{"lower" if loc <= SLICE_POINT else "higher"}'
            if outkey not in data:
                data[outkey] = []
            data[outkey].append({'loc': loc, 'value': value})

    for ins, slice in enumerate(['lower', 'higher']):
        ax = axs[inf][ins]
        print(f"-- SLOC {slice.upper()} --")
        for tool in tools:
            key = f"{tool}-{feature['key']}-{slice}"
            values = [item['value'] for item in data.get(key, []) if
                      not math.isnan(item['value']) and not math.isinf(item['value'])]
            if values:
                avg = sum(values) / len(values)
                print(f"{tools[tool][0]}: {avg:.2f}")
            else:
                print(f"{tools[tool][0]}: No Data")

            if tool == 'enre':
                enre_avg = avg if values else None
            elif tool == 'ark':
                ark_avg = avg if values else None


        if enre_avg and ark_avg:
            ratio = ark_avg / enre_avg
            print(f"Ratio (Arkanalyzer / ENRE): {ratio:.2f}")
        else:
            print("Ratio (Arkanalyzer / ENRE): N/A")


        bp = ax.boxplot(
            [list(map(lambda r: r['value'], data[f'{tool}-{feature["key"]}-{slice}'])) for tool in tools],
            widths=BOX_WIDTH,
            vert=False,
            positions=np.array(range(len(tools))) * HEIGHT,
            patch_artist=True,
            boxprops={'facecolor': LIGHT_GRAY, 'linewidth': 0},
            whiskerprops={'color': DARKER_GRAY},
            capprops={'color': DARKER_GRAY},
            flierprops={
                'marker': 'o',
                'markersize': 5,
                'markerfacecolor': LIGHT_GRAY,
                'markeredgecolor': LIGHT_GRAY,
            },
            medianprops={'color': LIGHT_GRAY},
        )

        statistic_values = [whisker.get_xdata() for whisker in bp['whiskers']]

        box_left_values = []
        box_right_values = []
        for it in range(len(tools)):
            whisker_left = statistic_values[it * 2][1]
            whisker_right = statistic_values[it * 2 + 1][1]
            box_left_values.append(whisker_left)
            box_right_values.append(whisker_right)

        # min_x = min(box_left_values)
        # max_x = max(box_right_values)
        min_x = min(x for x in box_left_values if not (math.isnan(x) or math.isinf(x)))
        max_x = max(x for x in box_right_values if not (math.isnan(x) or math.isinf(x)))
        # print(min_x)
        # print(max_x)
        padding = (max_x - min_x) * 0.1
        ax.set_xlim(max(0, min_x - padding), max_x + padding)
        # ======= result ==========

        ax.set_ylim([-0.5, len(tools) - 0.2])

        if ins == 0:
            ax.set_yticks(np.array(range(len(tools))) * HEIGHT,
                          labels=list(map(lambda key: tools[key][0], tools)),
                          fontdict={'fontsize': 14})
        else:
            ax.set_yticks([])

        medians = [median.get_xdata() for median in bp['medians']]
        for it, tool in enumerate(tools):
            curr_data = data[f'{tool}-{feature["key"]}-{slice}']
            whisker_left = statistic_values[it * 2][1]
            box_left = statistic_values[it * 2][0]
            box_right = statistic_values[it * 2 + 1][0]
            whisker_right = statistic_values[it * 2 + 1][1]
            max_right = ax.get_xlim()[1]
            step_size = max_right / HEAT_RESOLUTION
            for step in range(HEAT_RESOLUTION):
                cell_x = step * step_size
                drawing_types = []
                if box_left - step_size <= cell_x <= box_right:
                    drawing_types.append('box')
                if whisker_left - step_size <= cell_x <= box_left:
                    drawing_types.append('line-left')
                if box_right - step_size <= cell_x <= whisker_right:
                    drawing_types.append('line-right')
                if not drawing_types:
                    continue
                for drawing_type in drawing_types:
                    if drawing_type == 'box':
                        cell_left = max(box_left, cell_x)
                        cell_width = min(box_right - cell_x, cell_x + step_size, box_right - box_left)
                    elif drawing_type == 'line-left':
                        cell_left = max(whisker_left, cell_x)
                        cell_width = min(box_left - cell_x, cell_x + step_size, box_left - whisker_left)
                    elif drawing_type == 'line-right':
                        cell_left = max(box_right, cell_x)
                        cell_width = min(whisker_right - cell_x, cell_x + step_size, whisker_right - box_right)
                    items_in_range = list(filter(lambda item: cell_left <= item['value'] < cell_left + cell_width,
                                                 curr_data))
                    if len(items_in_range) == 0:
                        try:
                            items_in_range.append(sorted(
                                filter(lambda item: item['value'] < cell_left, curr_data),
                                key=lambda item: item['value'])[-1])
                            items_in_range.append(sorted(
                                filter(lambda item: item['value'] > cell_left + cell_width, curr_data),
                                key=lambda item: item['value'])[0])
                        except IndexError:
                            continue
                    avg_loc = sum(item['loc'] for item in items_in_range) / len(items_in_range)
                    color = cmapping((avg_loc - heat_min) / (heat_max_val - heat_min))
                    if drawing_type == 'box':
                        ax.add_patch(pch.Rectangle(
                            (cell_left, it - BOX_WIDTH / 2),
                            cell_width, BOX_WIDTH,
                            facecolor=color,
                            zorder=100,
                        ))
                    elif drawing_type.startswith('line'):
                        ax.plot(
                            [cell_left, cell_left + cell_width],
                            [it, it],
                            color=color,
                            zorder=100,
                        )
            median = medians[it][0]
            if not math.isnan(median):
                ax.add_patch(pch.Rectangle(
                    (median, it - BOX_WIDTH / 2),
                    max_right / 300, BOX_WIDTH,
                    facecolor='white',
                    zorder=101,
                ))
                median_txt = round(median, 1 if feature['key'] == 'time' else 2)
                ax.text(
                    median, it + 0.3,
                    median_txt,
                    size=10,
                    ha='left',
                    va='bottom',
                    zorder=9999,
                    color=DARKER_GRAY,
                    weight='bold',
                )
            # fliers
            cap_left = statistic_values[it * 2][1]
            cap_right = statistic_values[it * 2 + 1][1]
            for item in filter(lambda item: item['value'] < cap_left or item['value'] > cap_right, curr_data):
                ax.plot(
                    [item['value']], [it],
                    marker='o',
                    color=cmapping((item['loc'] - heat_min) / (heat_max_val - heat_min)),
                )
            outers = list(filter(lambda item: item['value'] > max_right, curr_data))
            if outers:
                outers_avg_loc = sum(item['loc'] for item in outers) / len(outers)
                t = ax.text(
                    max_right * 0.99, it,
                    f' +{len(outers)} ',
                    size=10,
                    ha='right',
                    va='center',
                    zorder=9999,
                    color='white',
                    weight='bold',
                )
                t.set_bbox({
                    'facecolor': cmapping((outers_avg_loc - heat_min) / (heat_max_val - heat_min)),
                    'linewidth': 0,
                    'boxstyle': 'round,pad=0.1,rounding_size=0.6',
                })
                upto = sorted([item['value'] for item in outers])[-1]
                upto = int(round(upto / 100, 0) * 100) if feature['key'] == 'time' and slice == 'higher' else round(upto, 1 if feature['key'] == 'time' else 2)
                ax.text(
                    max_right * 1.01, it,
                    f'Up to\n{upto}',
                    size=10,
                    ha='left',
                    va='center',
                    zorder=9999,
                    color=DARKER_GRAY,
                    weight='bold',
                )

if mode == 'view':
    fig.show()
else:
    fig.savefig(f'test.png')
