$(function() {
  pollForBalanceChange = function(balance) {
    if (balance  === 0) {
      $.get('/balance/<%= @data[:id] %>', function(data) { 
        if (swf_content.setToNewBalance === undefined || data.balance_in_mBTC === '0') {
          setTimeout(function() { pollForBalanceChange(0); }, 1000);
        }
        else {
          swf_content.setToNewBalance(data);
        }
      });
    }
  };

  pollForBalanceChange(balance_in_mBTC());
});
