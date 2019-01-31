# [![Build Status](https://travis-ci.org/keita-hino/slack-bot.svg?branch=master)](https://travis-ci.org/keita-hino/slack-bot)
# README

このslackbotはタスク管理用です。  

スラッシュコマンド一覧   
/task_add タスク名 due: 21:00   
  →タスクを追加する。dueオプションをつけると期限を設定することができる。   

/task_remove タスク名   
  →タスクを削除する。    

/task_complete タスク名   
  →タスクのステータスを「完了」にする。   

/task_show タスク名 range:today   
  →タスクの一覧を表示する。rangeオプションを指定することで任意の範囲のタスク一覧を取得することができる。    

/task_report    
  →完了したタスクなどから、日報を作成する。   

/task_modify    
  →タスクのステータスを変更する。    

/task_help    
  →各種コマンドの説明を表示する。    
