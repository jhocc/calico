export function userAndOther(channel, currentUserId) {
  const otherChannelUser = channel.get('channels_users').filter((channelUser) => (
    channelUser.get('user_id') !== currentUserId
  )).first()
  const channelUser = channel.get('channels_users').filter((channelUser) => (
    channelUser.get('user_id') === currentUserId
  )).first()
  return [channelUser, otherChannelUser]
}
