/*
 * Copyright (C) 2024 桃花镇童长老 @pura/harmony-dialog
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { CustomContentDialog } from '@kit.ArkUI';
import { BaseContentOptions } from '../model/base/BaseContentOptions';
import { TextAreaOptions } from '../model/TextAreaOptions';
import { DialogThemeColorMode, TextAlignment } from '../utils/constraint';
import { TextAreaModifier } from '../utils/TextAreaModifier';
import { CacheHelper } from '../utils/CacheHelper';


/**
 * TODO TextAreaDialog组件
 * author: 桃花镇童长老ᥫ᭡
 * since: 2024/08/01
 */
@Component
export struct TextAreaDialogView {
  private controller: TextInputController = new TextInputController()
  @Prop options: TextAreaOptions;
  @State customOptions: BaseContentOptions | undefined = undefined;
  @State modifier: TextAreaModifier = new TextAreaModifier();
  @State text: string = '';
  @State textAlignment: Alignment = Alignment.Top;
  @StorageProp(DialogThemeColorMode) themeColorMode: ThemeColorMode =
    this.options.themeColorMode ?? ThemeColorMode.SYSTEM; //设置深色浅色，默认跟随系统。


  aboutToAppear(): void {
    this.text = this.options.text ?? "";
    this.modifier.inputFilter = this.options.inputFilter;
    if (this.options.align == TextAlignment.Bottom) {
      this.textAlignment = Alignment.Bottom;
    } else if (this.options.align == TextAlignment.Center) {
      this.textAlignment = Alignment.Center;
    } else {
      this.textAlignment = Alignment.Top;
    }
    this.customOptions = (this.options as BaseContentOptions);
    this.customOptions.contentBuilder = () => {
      this.InputBuilder()
    }
    CacheHelper.put(`${CacheHelper.CACHE_LABEL}${this.options.dialogId ?? ""}`, this.text);
  }

  build() {
    if (this.themeColorMode === ThemeColorMode.LIGHT) {
      WithTheme({ colorMode: ThemeColorMode.LIGHT }) {
        CustomContentDialog(this.customOptions)
          .height(this.options.height)
          .width(this.options.width)
          .constraintSize({ maxWidth: this.options.maxWidth, maxHeight: this.options.maxHeight })
          .backgroundColor(this.options.backgroundColor)
          .backgroundBlurStyle(this.options.backgroundBlurStyle)
          .borderRadius(this.options.cornerRadius)
          .borderWidth(this.options.borderWidth)
          .borderColor(this.options.borderColor)
          .borderStyle(this.options.borderStyle)
          .clip(true)
      }
    } else if (this.themeColorMode === ThemeColorMode.DARK) {
      WithTheme({ colorMode: ThemeColorMode.DARK }) {
        CustomContentDialog(this.customOptions)
          .height(this.options.height)
          .width(this.options.width)
          .constraintSize({ maxWidth: this.options.maxWidth, maxHeight: this.options.maxHeight })
          .backgroundColor(this.options.backgroundColor)
          .backgroundBlurStyle(this.options.backgroundBlurStyle)
          .borderRadius(this.options.cornerRadius)
          .borderWidth(this.options.borderWidth)
          .borderColor(this.options.borderColor)
          .borderStyle(this.options.borderStyle)
          .clip(true)
      }
    } else {
      CustomContentDialog(this.customOptions)
        .height(this.options.height)
        .width(this.options.width)
        .constraintSize({ maxWidth: this.options.maxWidth, maxHeight: this.options.maxHeight })
        .backgroundColor(this.options.backgroundColor)
        .backgroundBlurStyle(this.options.backgroundBlurStyle)
        .borderRadius(this.options.cornerRadius)
        .borderWidth(this.options.borderWidth)
        .borderColor(this.options.borderColor)
        .borderStyle(this.options.borderStyle)
        .clip(true)
    }
  }


  @Builder
  InputBuilder() {
    WithTheme({ colorMode: this.themeColorMode }) {
      TextArea({
        controller: this.controller,
        text: $$this.text,
        placeholder: this.options.placeholder ?? '请输入'
      })
        .type(this.options.inputType ?? TextAreaType.NORMAL)
        .defaultFocus(this.options.defaultFocus)
        .fontSize(this.options.fontSize)
        .fontColor(this.options.fontColor)
        .fontSize(this.options.fontSize)
        .placeholderColor(this.options.placeholderColor)
        .textAlign(this.options.textAlign)
        .align(this.textAlignment)
        .lineHeight(this.options.inputLineHeight)
        .backgroundColor(this.options.inputBackgroundColor)
        .border(this.options.inputBorder ?? { radius: 8 })
        .maxLength(this.options.maxLength == 0 ? Infinity : this.options.maxLength)
        .attributeModifier(this.modifier)
        .width('100%')
        .height(this.options.inputHeight ?? 155)//默认155
        .padding({ top: 12, bottom: 12 })
        .onChange((value: string, previewText?: PreviewText) => {
          CacheHelper.put(`${CacheHelper.CACHE_LABEL}${this.options.dialogId ?? ""}`, value ?? "");
          if (this.options.onChange) {
            this.options.onChange(value);
          }
        })
    }
  }


}