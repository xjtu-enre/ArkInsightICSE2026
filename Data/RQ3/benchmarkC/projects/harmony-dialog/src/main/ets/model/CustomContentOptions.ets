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

import { ActionStrCallBack } from '../utils/constraint';
import { BaseContentOptions } from './base/BaseContentOptions';
import { ButtonOptions } from './ButtonOptions'

/**
 * TODO 自定义内容区弹出框，参数类
 * author: 桃花镇童长老ᥫ᭡
 * since: 2024/08/18
 */
export interface CustomContentOptions extends BaseContentOptions {

  buttons?: Array<ResourceStr | ButtonOptions>; //弹出框操作区按钮，最多支持4个按钮。
  onAction?: ActionStrCallBack; //按钮的CallBack事件。

  contentBuilder: () => void; //弹出框内容，自定义

}