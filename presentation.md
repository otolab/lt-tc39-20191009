title: WeakRefs
class: animation-fade
layout: true

<!-- This slide will serve as the base layout for all your slides -->
.bottom-bar[
  {{title}}
]

---

class: impact

# {{title}}
## by @otolab


---

class: impact

## Javascriptに『弱い参照』が導入されます

???




---

# 誰？

.col-6[

加藤 尚人

勤務先: 株式会社プレイド

github: @otolab

twitter: @otoan52

]

.col-1[
]

.col-4[
![](https://avatars3.githubusercontent.com/u/6499878?s=460&v=4)
]


---

# 弱い参照とは

* GCがカウントしない参照
* 弱い参照だけが残っていてもGCは片付ける（かもしれない）
* GCありの言語にはよくある

---

# WeakReferences TC39 proposal

* Stage 3
* URL: https://github.com/tc39/proposal-weakrefs
* 対応
  - Chrome 74、Node 12.0 以降(`--harmony-weak-refs`が必要)
* 追加されるもの
  - WeakRef
  - Finalization

---

# WeakRef

弱い参照を表すクラス

--

用途：

* あるなしをGC任せにしたいもの
* なくてもいいがあったほうがいいもの

--

例：

* キャッシュ

---

# WeakRef: usage

```javascript
const ref = new WeakRef(obj)
```

```javascript
const obj = ref.deref()
```

--

* 解放済みであるときderef()はundefinedを返す
* delef()は同一スレッド中は同じ状態を返すことが保証される


---

# Finalization

GCがオブジェクトを片付けたときにハンドリングする仕組み

--

用途：

* オブジェクトが本当になくなったあとに行いたい処理
* 外部のリソースをJavascriptで利用するときの解放処理

--

例：

* Worker間で共有を行っているときのデータの寿命同期


---

# Finalization: usage

```javascript
const group = new FinalizationGroup((itr) => {
  for (const key of itr) {
    // ...
  }
})

const obj = new Object()
group.register(obj, 'key', 'unregister-key')
```

--

* ハンドラは解放**後**に呼ばれる
* ハンドラは直後に呼ばれるとは限らない
* `group.unregister('unregister-key')` で登録を解除できる


---

# 組み合わせ


例: GCで掃除されるまでオブジェクトをキャッシュしておく

* WeakRefでキャッシュしたいオブジェクトを持つ
* FinalizationでオブジェクトがGCされたあとに項目を掃除する


---

# 組み合わせ: コード例

```javascript
const caches = {}
const group = new FinalizationGroup((itr) => {
  for (const key of itr) {
    if (key in caches && !caches[key].deref()) delete caches[key];
  }
})

function set(key, obj) {
  const ref = new WeakRef(obj)
  caches[key] = ref
  group.register(obj, key)
}

function get(key) {
  return caches[key] && caches[key].deref() || undefined
}
```

---


# 参考：WeakMap, WeakSet

キーにしたオブジェクトに対して弱い参照を持つ

--

用途：

* あるオブジェクトに対する情報を保持したい
* そのオブジェクトは不要になったらGCされてほしい

--

例：

* あるデータの処理回数を記録する
* DOMノードにデータを紐付ける

---

# まとめ

* ２つともGC在りきの機能
* よりうまくGCと付き合いたいというプロポーサルだと感じた

---

class: impact

## ありがとうございました！

