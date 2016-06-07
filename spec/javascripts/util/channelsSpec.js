import * as Util from 'util/channels'
import Immutable from 'immutable'

describe('userAndOther', () => {
  it('returns an array where the first element is the current user and the last element is not', () => {
    const fry = { user_id: 44, user: { first_name: 'Phillip', last_name: 'Fry' } }
    const me = { user_id: 77, user: { first_name: 'Me', last_name: 'And Myself' } }
    const channel = Immutable.fromJS({
      channels_users: [fry, me],
    })
    expect(Util.userAndOther(channel, me.user_id)[0].toJS()).toEqual(me)
    expect(Util.userAndOther(channel, me.user_id)[1].toJS()).toEqual(fry)
    expect(Util.userAndOther(channel, fry.user_id)[0].toJS()).toEqual(fry)
    expect(Util.userAndOther(channel, fry.user_id)[1].toJS()).toEqual(me)
  })
})
